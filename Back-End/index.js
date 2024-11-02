const express = require("express");
const bodyParser = require("body-parser");
const http = require("http");
const WebSocket = require("ws");
const cors = require("cors");
const rateLimit = require("express-rate-limit");
require("dotenv").config();
require("./config/db.js");

const app = express();

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
});

app.use(limiter);

// CORS configuration
const corsOptions = {
  origin: [
    "https://seyoni.onrender.com",
    "http://localhost:3000",
    "http://localhost:8080",
  ],
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization", "x-requested-with"],
  credentials: true,
  maxAge: 86400,
};

app.use(cors(corsOptions));

// Security headers
app.use((req, res, next) => {
  res.setHeader("X-Content-Type-Options", "nosniff");
  res.setHeader("X-Frame-Options", "DENY");
  res.setHeader("X-XSS-Protection", "1; mode=block");
  res.setHeader(
    "Strict-Transport-Security",
    "max-age=31536000; includeSubDomains"
  );
  next();
});

app.use(bodyParser.json({ limit: "10mb" }));
app.use(bodyParser.urlencoded({ extended: true, limit: "10mb" }));

// Routes
app.use("/api/otp", require("./routes/otpRoutes"));
app.use("/api/provider", require("./routes/providerRoutes"));
app.use("/api/reservations", require("./routes/reservationRoutes"));
app.use("/api/seeker", require("./routes/seekerRoutes"));

const server = http.createServer(app);
const wss = new WebSocket.Server({
  server,
  path: "/ws",
  verifyClient: async (info, callback) => {
    try {
      const origin = info.origin || info.req.headers.origin;
      const isAllowed = corsOptions.origin.includes(origin);

      // Add token verification if needed
      // const token = info.req.headers.authorization;
      // const isValidToken = await verifyToken(token);

      callback(isAllowed, 403, "Forbidden");
    } catch (error) {
      console.error("WebSocket verification error:", error);
      callback(false, 500, "Internal Server Error");
    }
  },
});

const clients = new Set();

// Message validation schemas
const messageSchemas = {
  otp_update: (data) => data.otp && data.reservationId,
  section_update: (data) => typeof data.section === "number",
  timer_update: (data) => typeof data.value === "number",
  payment_update: (data) =>
    data.method && data.status && typeof data.amount === "number",
};

function heartbeat() {
  this.isAlive = true;
}

wss.on("connection", (ws) => {
  console.log("Client connected");
  ws.isAlive = true;
  ws.on("pong", heartbeat);
  clients.add(ws);

  let messageCount = 0;
  const messageLimit = 100;
  const resetInterval = setInterval(() => {
    messageCount = 0;
  }, 60000);

  ws.on("message", (message) => {
    // Rate limiting per connection
    messageCount++;
    if (messageCount > messageLimit) {
      ws.send(JSON.stringify({ error: "Too many messages" }));
      return;
    }

    const messageStr = message.toString();
    if (messageStr === "ping") {
      ws.send("pong");
      return;
    }

    try {
      const data = JSON.parse(messageStr);

      // Validate message structure
      if (!data.type || !messageSchemas[data.type]) {
        throw new Error("Invalid message type");
      }

      // Validate message data
      if (!messageSchemas[data.type](data)) {
        throw new Error("Invalid message data");
      }

      switch (data.type) {
        case "otp_update":
          broadcastMessage({
            type: "otp_update",
            otp: data.otp,
            reservationId: data.reservationId,
          });
          break;

        case "section_update":
          broadcastMessage({
            type: "section_update",
            section: data.section,
          });
          break;

        case "timer_update":
          broadcastMessage({
            type: "timer_update",
            value: data.value,
          });
          break;

        case "payment_update":
          broadcastMessage({
            type: "payment_update",
            method: data.method,
            status: data.status,
            amount: data.amount,
          });
          break;
      }
    } catch (err) {
      if (!messageStr.includes("ping")) {
        console.error("Error processing message:", err);
        ws.send(JSON.stringify({ error: err.message }));
      }
    }
  });

  ws.on("error", (error) => {
    console.error("WebSocket error:", error);
  });

  ws.on("close", () => {
    console.log("Client disconnected");
    clients.delete(ws);
    clearInterval(resetInterval);
  });
});

const heartbeatInterval = setInterval(() => {
  wss.clients.forEach((ws) => {
    if (ws.isAlive === false) {
      clients.delete(ws);
      return ws.terminate();
    }
    ws.isAlive = false;
    ws.ping();
  });
}, 30000);

wss.on("close", () => {
  clearInterval(heartbeatInterval);
});

function broadcastMessage(message, sender = null) {
  try {
    const messageStr = JSON.stringify(message);
    clients.forEach((client) => {
      if (client !== sender && client.readyState === WebSocket.OPEN) {
        client.send(messageStr);
      }
    });
  } catch (error) {
    console.error("Broadcast error:", error);
  }
}

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "ok",
    connections: clients.size,
  });
});

const port = process.env.PORT || 3000;
const host = "0.0.0.0";

const serverInstance = server.listen(port, host, () => {
  console.log(`Server running on http://${host}:${port}`);
  console.log(`WebSocket server running on ws://${host}:${port}/ws`);
});

// Graceful shutdown
process.on("SIGTERM", () => {
  console.log("Received SIGTERM. Starting graceful shutdown...");
  serverInstance.close(() => {
    wss.close(() => {
      clearInterval(heartbeatInterval);
      console.log("Server shutdown complete");
      process.exit(0);
    });
  });
});

process.on("uncaughtException", (error) => {
  console.error("Uncaught Exception:", error);
});

process.on("unhandledRejection", (reason, promise) => {
  console.error("Unhandled Rejection:", reason);
});
