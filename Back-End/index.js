require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const http = require("http");
const WebSocket = require("ws");
const { generateOtp } = require("./services/otpService"); // Adjust the path as necessary
require("./config/db.js"); // Ensure the database connection is established

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Your existing routes
app.use("/api", require("./routes/otpRoutes"));
app.use("/api/provider", require("./routes/providerRoutes")); // Ensure this line exists

// Create an HTTP server
const server = http.createServer(app);

// Set up WebSocket server
const wss = new WebSocket.Server({ server });

wss.on("connection", (ws) => {
  ws.on("message", (message) => {
    const data = JSON.parse(message);
    if (data.type === "send_otp") {
      const otp = generateOtp(data.seeker_id); // Generate OTP
      ws.send(JSON.stringify({ type: "otp", otp })); // Send OTP to seeker
    }
  });
});

const port = process.env.PORT || 3000;
const host = "0.0.0.0"; // Bind to all network interfaces

server.listen(port, host, () => {
  console.log(`Server is listening on port ${port}`);
});
