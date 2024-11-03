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

const clients = new Map();

// Message validation schemas
const messageSchemas = {
  identify: (data) => data.userId && data.userType,
  otp_update: (data) =>
    data.type === "otp_update" &&
    data.seekerId &&
    data.otp &&
    data.reservationId,
  section_update: (data) =>
    typeof data.section === "number" && data.reservationId,
  timer_update: (data) => typeof data.value === "number" && data.reservationId,
  payment_update: (data) =>
    data.method &&
    data.status &&
    typeof data.amount === "number" &&
    data.reservationId,
};

function heartbeat() {
  this.isAlive = true;
}

function broadcastToReservation(message, reservationId, excludeClient = null) {
  const messageStr = JSON.stringify(message);
  clients.forEach((clientInfo, clientId) => {
    const { ws, reservations } = clientInfo;
    if (
      ws !== excludeClient &&
      ws.readyState === WebSocket.OPEN &&
      reservations.includes(reservationId)
    ) {
      ws.send(messageStr);
    }
  });
}

function sendToUser(userId, message) {
  const clientInfo = clients.get(userId);
  if (clientInfo && clientInfo.ws.readyState === WebSocket.OPEN) {
    clientInfo.ws.send(JSON.stringify(message));
  }
}

wss.on("connection", (ws) => {
  console.log("Client connected");
  ws.isAlive = true;
  ws.on("pong", heartbeat);

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

      if (!data.type || !messageSchemas[data.type]) {
        throw new Error("Invalid message type");
      }

      if (!messageSchemas[data.type](data)) {
        throw new Error("Invalid message data");
      }

      switch (data.type) {
        case "identify":
          clients.set(data.userId, {
            ws,
            userType: data.userType,
            reservations: [],
          });
          ws.userId = data.userId;
          break;

        case "otp_update":
          if (!data.seekerId || !data.otp || !data.reservationId) {
            throw new Error("Missing required OTP update data");
          }
          const targetSeeker = Array.from(clients.values()).find(
            (client) =>
              client.userType === "seeker" && client.ws.userId === data.seekerId
          );

          if (targetClient) {
            // Send OTP only to the specific seeker
            targetClient.ws.send(
              JSON.stringify({
                type: "otp_update",
                otp: data.otp,
                reservationId: data.reservationId,
              })
            );

            // Add the reservation ID to both provider and seeker clients
            if (ws.userId) {
              const providerClient = clients.get(ws.userId);
              if (providerClient) {
                providerClient.reservations.push(data.reservationId);
              }

              const seekerClientInfo = clients.get(data.seekerId);
              if (seekerClientInfo) {
                seekerClientInfo.reservations.push(data.reservationId);
              }
            }
          }
          break;

        case "section_update":
        case "timer_update":
        case "payment_update":
          broadcastToReservation(data, data.reservationId, ws);
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
    if (ws.userId) {
      clients.delete(ws.userId);
    }
    clearInterval(resetInterval);
  });
});

const heartbeatInterval = setInterval(() => {
  wss.clients.forEach((ws) => {
    if (ws.isAlive === false) {
      if (ws.userId) {
        clients.delete(ws.userId);
      }
      return ws.terminate();
    }
    ws.isAlive = false;
    ws.ping();
  });
}, 30000);

wss.on("close", () => {
  clearInterval(heartbeatInterval);
});

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
