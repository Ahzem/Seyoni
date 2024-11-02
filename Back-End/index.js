const express = require("express");
const bodyParser = require("body-parser");
const http = require("http");
const WebSocket = require("ws");
const cors = require("cors"); // Add this line
require("dotenv").config();
require("./config/db.js");

const app = express();

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
  maxAge: 86400, // CORS preflight cache time in seconds
};

// Apply CORS middleware
app.use(cors(corsOptions));

// Security headers
app.use((req, res, next) => {
  res.setHeader("X-Content-Type-Options", "nosniff");
  res.setHeader("X-Frame-Options", "DENY");
  res.setHeader("X-XSS-Protection", "1; mode=block");
  next();
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
app.use("/api/otp", require("./routes/otpRoutes"));
app.use("/api/provider", require("./routes/providerRoutes"));
app.use("/api/reservations", require("./routes/reservationRoutes"));
app.use("/api/seeker", require("./routes/seekerRoutes"));

const server = http.createServer(app);

// WebSocket server with CORS
const wss = new WebSocket.Server({
  server,
  path: "/ws",
  verifyClient: (info, callback) => {
    const origin = info.origin || info.req.headers.origin;
    const isAllowed = corsOptions.origin.includes(origin);
    callback(isAllowed, 403, "Forbidden");
  },
});

// Rest of your existing WebSocket code...

// Track connected clients
const clients = new Set();

wss.on("connection", (ws) => {
  console.log("Client connected");
  clients.add(ws);

  ws.on("message", (message) => {
    try {
      const data = JSON.parse(message);

      // Handle different message types
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

        default:
          console.log("Unknown message type:", data.type);
      }
    } catch (err) {
      console.error("Error processing message:", err);
    }
  });

  ws.on("error", (error) => {
    console.error("WebSocket error:", error);
  });

  ws.on("close", () => {
    console.log("Client disconnected");
    clients.delete(ws);
  });
});

// Broadcast message to all clients except sender
function broadcastMessage(message, sender = null) {
  const messageStr = JSON.stringify(message);
  clients.forEach((client) => {
    if (client !== sender && client.readyState === WebSocket.OPEN) {
      client.send(messageStr);
    }
  });
}

// Health check endpoint
app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

const port = process.env.PORT || 3000;
const host = "0.0.0.0";

server.listen(port, host, () => {
  console.log(`Server running on http://${host}:${port}`);
  console.log(`WebSocket server running on ws://${host}:${port}/ws`);
});

// Handle server shutdown
process.on("SIGTERM", () => {
  server.close(() => {
    console.log("Server shutdown complete");
    process.exit(0);
  });
});
