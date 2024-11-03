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
  windowMs: 15 * 60 * 1000,
  max: 100,
});

app.use(limiter);

const corsOptions = {
  origin: [
    "https://seyoni.onrender.com",
    "http://localhost:3000",
    "http://localhost:8080",
  ],
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
  allowedHeaders: [
    "Content-Type",
    "Authorization",
    "x-requested-with",
    "User-ID",
    "User-Type",
  ],
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

// WebSocket Server Setup
const wss = new WebSocket.Server({
  server,
  path: "/ws",
  clientTracking: true,
  verifyClient: async (info, callback) => {
    try {
      const origin = info.origin || info.req.headers.origin;
      const userId = info.req.headers["user-id"];
      const userType = info.req.headers["user-type"];

      const isAllowed = corsOptions.origin.includes(origin);

      if (isAllowed && userId && userType) {
        info.req.userId = userId;
        info.req.userType = userType;
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

// Client tracking
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
      data.seekerId && data.otp && data.otp.length === 6 && data.reservationId
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

// WebSocket connection handling
wss.on("connection", (ws, req) => {
  console.log("Client connected:", req.userId, req.userType);

  ws.isAlive = true;
  ws.userId = req.userId;
  ws.userType = req.userType;

  // Add client to tracking
  clients.set(req.userId, {
    ws,
    userType: req.userType,
    reservations: [],
  });

  ws.on("pong", heartbeat);

  // Rate limiting
  let messageCount = 0;
  const messageLimit = 100;
  const resetInterval = setInterval(() => {
    messageCount = 0;
  }, 60000);

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
      console.log("Received message:", data);

      if (!data.type || !messageSchemas[data.type]) {
        throw new Error("Invalid message type");
      }

      if (!messageSchemas[data.type](data)) {
        throw new Error("Invalid message data");
      }

      switch (data.type) {
        case "identify":
          // Client already identified during connection
          break;

        case "otp_update":
          const otpSent = sendToUser(data.seekerId, {
            type: "otp_update",
            otp: data.otp,
            reservationId: data.reservationId,
          });

          if (otpSent) {
            // Update reservations tracking
            const providerClient = clients.get(ws.userId);
            const seekerClient = clients.get(data.seekerId);

            if (
              providerClient &&
              !providerClient.reservations.includes(data.reservationId)
            ) {
              providerClient.reservations.push(data.reservationId);
            }
            if (
              seekerClient &&
              !seekerClient.reservations.includes(data.reservationId)
            ) {
              seekerClient.reservations.push(data.reservationId);
            }

            console.log(`OTP sent to seeker ${data.seekerId}`);
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
      console.error("Error processing message:", err);
      ws.send(JSON.stringify({ error: err.message }));
    }
  });

  ws.on("error", (error) => {
    console.error("WebSocket error:", error);
  });

  ws.on("close", () => {
    console.log("Client disconnected:", ws.userId);
    clients.delete(ws.userId);
    clearInterval(resetInterval);
  });
});

// Heartbeat check
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
