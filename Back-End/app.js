const express = require("express");
const bodyParser = require("body-parser");
const SeekerRouter = require("./routes/seekerRoutes");
const UserRouter = require("./routes/userRoutes");
const ReservationRouter = require("./routes/reservationRoutes");
const providerRoutes = require("./routes/providerRoutes");
const app = express();

app.use(express.json());
app.use(bodyParser.json());

app.use("/api/seeker", SeekerRouter);
app.use("/api/user", UserRouter);
app.use("/api", ReservationRouter);
app.use("/api", providerRoutes);

app.get("/", (req, res) => {
  res.send("Hello Ahzem! I'm a Node.js app!");
});

module.exports = app;
