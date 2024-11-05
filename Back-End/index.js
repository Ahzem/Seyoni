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
app.set("trust proxy", 1);

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  standardHeaders: true,
  legacyHeaders: false,
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
// index.js
const wss = new WebSocket.Server({
  server,
  path: "/ws",
  clientTracking: true,
  verifyClient: async (info, callback) => {
    try {
      const origin = info.origin || info.req.headers.origin;
      const isAllowed = corsOptions.origin.includes(origin);

      // Accept upgrade request
      if (isAllowed) {
        callback(true);
      } else {
        callback(false, 403, "Forbidden");
      }
    } catch (error) {
      console.error("WebSocket verification error:", error);
      callback(false, 500, "Internal Server Error");
    }
  },
});

const clients = new Map();

// Message validation schemas
const messageSchemas = {
  identify: (data) => {
    return (
      data.type === "identify" &&
      typeof data.userId === "string" &&
      typeof data.userType === "string" &&
      ["seeker", "provider"].includes(data.userType)
    );
  },

  otp_update: (data) => {
    return (
      data.type === "otp_update" &&
      typeof data.seekerId === "string" &&
      typeof data.otp === "string" &&
      typeof data.reservationId === "string" &&
      data.otp.length === 6
    );
  },

  section_update: (data) => {
    return (
      data.type === "section_update" &&
      Number.isInteger(data.section) &&
      data.section >= 0 &&
      data.section <= 2 &&
      typeof data.reservationId === "string"
    );
  },

  timer_update: (data) => {
    return (
      data.type === "timer_update" &&
      Number.isInteger(data.value) &&
      data.value >= 0 &&
      typeof data.reservationId === "string"
    );
  },

  payment_update: (data) => {
    return (
      data.type === "payment_update" &&
      typeof data.method === "string" &&
      typeof data.status === "string" &&
      typeof data.amount === "number" &&
      typeof data.reservationId === "string"
    );
  },
};

function heartbeat() {
  this.isAlive = true;
}

function broadcastToReservation(message, reservationId, excludeClient = null) {
  if (!reservationId) {
    console.log("Warning: Missing reservationId in broadcast"); // Add debug log
    return;
  }

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
    return true;
  }
  return false;
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
      console.log("Received message:", data);

      if (!data.type || !messageSchemas[data.type]) {
        console.log("Invalid message type:", data.type);
        throw new Error("Invalid message type");
      }

      if (!messageSchemas[data.type](data)) {
        console.log("Schema validation failed for:", data);
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

          // Send OTP only to specific seeker
          const seekerClient = clients.get(data.seekerId);
          if (seekerClient && seekerClient.ws.readyState === WebSocket.OPEN) {
            seekerClient.ws.send(
              JSON.stringify({
                type: "otp_update",
                otp: data.otp,
                reservationId: data.reservationId,
              })
            );

            // Add reservation to both provider and seeker
            if (ws.userId) {
              const providerClient = clients.get(ws.userId);
              if (providerClient) {
                providerClient.reservations.push(data.reservationId);
              }
              seekerClient.reservations.push(data.reservationId);
            }
          } else {
            console.log(`Seeker ${data.seekerId} not connected`);
            ws.send(JSON.stringify({ error: "Seeker not connected" }));
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
