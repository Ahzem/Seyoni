const express = require("express");
const bodyParser = require("body-parser");
const SeekerRouter = require("./routes/seekerRoutes");
const ReservationRouter = require("./routes/reservationRoutes");
const providerRoutes = require("./routes/providerRoutes");
const otpRoutes = require("./routes/otpRoutes");
const app = express();

app.use(express.json());
app.use(bodyParser.json());

app.use("/api/seeker", SeekerRouter);
app.use("/api/reservations", ReservationRouter);
app.use("/api/providers", providerRoutes);
app.use("/api/otp", otpRoutes);

app.get("/", (req, res) => {
  res.send("Hello Ahzem! I'm a Node.js app!");
});

module.exports = app;
