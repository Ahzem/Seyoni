const express = require("express");
const bodyParser = require("body-parser");
const http = require("http");
const WebSocket = require("ws");
require("dotenv").config();
require("./config/db.js");

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Your existing routes
app.use("/api/otp", require("./routes/otpRoutes")); // Ensure this line exists
app.use("/api/provider", require("./routes/providerRoutes"));
app.use("/api/reservations", require("./routes/reservationRoutes"));
app.use("/api/seeker", require("./routes/seekerRoutes"));

const server = http.createServer(app);

const wss = new WebSocket.Server({ server });

wss.on("connection", (ws) => {
  ws.on("message", (message) => {
    const data = JSON.parse(message);
    if (data.type === "send_otp") {
      const otp = data.otp;
      // Broadcast OTP to all connected clients
      wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
          client.send(JSON.stringify({ type: "otp", otp }));
        }
      });
    }
  });
});

const port = process.env.PORT || 3000;
const host = "0.0.0.0";

server.listen(port, host, () => {
  console.log(`Server is listening on port ${port}`);
});
