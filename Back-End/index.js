const express = require("express");
const bodyParser = require("body-parser");
const http = require("http");
const WebSocket = require("ws");
const cors = require("cors");
const rateLimit = require("express-rate-limit");
require("dotenv").config();
require("./config/db.js");

const app = express();

// Trust the proxy
app.set("trust proxy", true);

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
});

app.use(limiter);

const corsOptions = {
  origin: [
    "https://seyoni.onrender.com",
    "http://localhost:3000",
    "http://localhost:8080",
    "file://", // For Flutter debug mode
  ],
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
  allowedHeaders: [
    "Content-Type",
    "Authorization",
    "x-requested-with",
    "User-ID",
    "User-Type",
    "Connection",
    "Upgrade",
    "Sec-WebSocket-Key",
    "Sec-WebSocket-Version",
  ],
  credentials: true,
  maxAge: 86400,
};

app.use(cors(corsOptions));

// Security headers middleware
const securityHeaders = (req, res, next) => {
  res.setHeader("X-Content-Type-Options", "nosniff");
  res.setHeader("X-Frame-Options", "DENY");
  res.setHeader("X-XSS-Protection", "1; mode=block");
  res.setHeader(
    "Strict-Transport-Security",
    "max-age=31536000; includeSubDomains"
  );
  next();
};

app.use(securityHeaders);

app.use(bodyParser.json({ limit: "10mb" }));
app.use(bodyParser.urlencoded({ extended: true, limit: "10mb" }));

// Routes
app.use("/api/otp", require("./routes/otpRoutes"));
app.use("/api/provider", require("./routes/providerRoutes"));
app.use("/api/reservations", require("./routes/reservationRoutes"));
app.use("/api/seeker", require("./routes/seekerRoutes"));

const server = http.createServer(app);

// WebSocket Server Setup with custom header handling
// In index.js, update the WebSocket server setup
const wss = new WebSocket.Server({
  server,
  path: "/ws",
  clientTracking: true,
  verifyClient: (info, cb) => {
    const userId = info.req.headers["user-id"];
    const userType = info.req.headers["user-type"];

    if (userId && userType) {
      info.req.userId = userId;
      info.req.userType = userType;
      cb(true);
    } else {
      console.log("WebSocket connection rejected:", {
        userId,
        userType,
      });
      cb(false, 403, "Forbidden");
    }
  },
});

// Client tracking with enhanced metadata
const clients = new Map();

// Message validation schemas
const messageSchemas = {
  identify: (data) => {
    return (
      data.userId &&
      data.userType &&
      ["seeker", "provider"].includes(data.userType)
    );
  },
  otp_update: (data) => {
    return (
      data.otp && 
      data.otp.length === 6 && 
      data.reservationId
    );
  },

  section_update: (data) => {
    return (
      Number.isInteger(data.section) &&
      data.section >= 0 &&
      data.section <= 2 &&
      data.reservationId
    );
  },
  timer_update: (data) => {
    return (
      Number.isInteger(data.value) && data.value >= 0 && data.reservationId
    );
  },
  payment_update: (data) => {
    return (
      data.method &&
      data.status &&
      typeof data.amount === "number" &&
      data.reservationId
    );
  },
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
      (message.type === 'otp_update' || reservations.includes(reservationId))
    ) {
      try {
        ws.send(messageStr);
        console.log(
          `Message sent to client ${clientId} for reservation ${reservationId}`
        );
      } catch (e) {
        console.error(`Failed to send message to client ${clientId}:`, e);
      }
    }
  });
}

function sendToUser(userId, message) {
  const clientInfo = clients.get(userId);
  if (clientInfo && clientInfo.ws.readyState === WebSocket.OPEN) {
    try {
      clientInfo.ws.send(JSON.stringify(message));
      console.log(`Message sent to user ${userId}:`, message);
      return true;
    } catch (e) {
      console.error(`Failed to send message to user ${userId}:`, e);
      return false;
    }
  }
  return false;
}

wss.on("connection", (ws, req) => {
  console.log("New client connected:", req.userId, req.userType);

  ws.isAlive = true;
  ws.userId = req.userId;
  ws.userType = req.userType;

  // Store client information
  clients.set(req.userId, {
    ws,
    userType: req.userType,
    reservations: [],
    lastMessageTime: Date.now(),
  });

  ws.on("pong", heartbeat);

  // Rate limiting setup
  let messageCount = 0;
  const messageLimit = 100;
  const resetInterval = setInterval(() => {
    messageCount = 0;
  }, 60000);

  // Inside the WebSocket connection handler (wss.on("connection"))
  ws.on("message", async (message) => {
    messageCount++;
    if (messageCount > messageLimit) {
      ws.send(JSON.stringify({ error: "Too many messages" }));
      return;
    }
  
    try {
      const messageStr = message.toString();
  
      if (messageStr === "ping") {
        ws.send("pong");
        return;
      }
  
      const data = JSON.parse(messageStr);
      console.log("Received message from", ws.userId, ":", data);
  
      if (!data.type || !messageSchemas[data.type]) {
        throw new Error("Invalid message type");
      }
  
      if (!messageSchemas[data.type](data)) {
        throw new Error("Invalid message data");
      }
  
      const clientInfo = clients.get(ws.userId);
      const now = Date.now();
      const minMessageInterval = 1000; // 1 second
  
      if (now - clientInfo.lastMessageTime < minMessageInterval) {
        return; // Rate limiting per client
      }
      clientInfo.lastMessageTime = now;
  
      switch (data.type) {
        case "identify":
          // Client already identified during connection
          break;
  
        case "otp_update":
          // Broadcast to all clients involved in the reservation
          broadcastToReservation(
            {
              type: "otp_update",
              otp: data.otp,
              reservationId: data.reservationId
            },
            data.reservationId,
            ws
          );
  
          // Track reservation for both provider and seeker
          const providerClient = clients.get(ws.userId);
          if (providerClient && !providerClient.reservations.includes(data.reservationId)) {
            providerClient.reservations.push(data.reservationId);
          }
  
          // If seeker is connected, track reservation
          const seekerClient = clients.get(data.seekerId);
          if (seekerClient && !seekerClient.reservations.includes(data.reservationId)) {
            seekerClient.reservations.push(data.reservationId);
          }
  
          console.log(`OTP broadcast for reservation ${data.reservationId}`);
          break;
  
        case "section_update":
          broadcastToReservation(data, data.reservationId, ws);
          break;
  
        case "timer_update":
          broadcastToReservation(data, data.reservationId, ws);
          break;
  
        case "payment_update":
          broadcastToReservation(data, data.reservationId, ws);
          break;
  
        default:
          throw new Error("Unknown message type");
      }
    } catch (err) {
      console.error("Error processing message:", err);
      ws.send(JSON.stringify({ error: err.message }));
    }
  });

  ws.on("error", (error) => {
    console.error("WebSocket error for client", ws.userId, ":", error);
  });

  ws.on("close", () => {
    console.log("Client disconnected:", ws.userId);
    clients.delete(ws.userId);
    clearInterval(resetInterval);
  });
});

// Heartbeat interval
const heartbeatInterval = setInterval(() => {
  wss.clients.forEach((ws) => {
    if (ws.isAlive === false) {
      clients.delete(ws.userId);
      return ws.terminate();
    }
    ws.isAlive = false;
    ws.ping();
  });
}, 30000);

wss.on("close", () => {
  clearInterval(heartbeatInterval);
});

// Health check endpoint
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "ok",
    connections: clients.size,
    uptime: process.uptime(),
  });
});

// Server startup
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

module.exports = { app, wss, server: serverInstance };
