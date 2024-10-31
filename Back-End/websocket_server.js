// const WebSocket = require("ws");
// const { generateOtp } = require("./services/otpService"); // Adjust the path as necessary

// const wss = new WebSocket.Server({ port: 8080 });

// wss.on("connection", (ws) => {
//   ws.on("message", (message) => {
//     const data = JSON.parse(message);
//     if (data.type === "send_otp") {
//       const otp = generateOtp(data.seeker_id); // Generate OTP
//       ws.send(JSON.stringify({ type: "otp", otp })); // Send OTP to seeker
//     }
//   });
// });

// console.log("WebSocket server is running on ws://localhost:8080");
