const express = require("express");
const bodyParser = require("body-parser");
const SeekerRouter = require("./routes/seekerRoutes");
const UserRouter = require("./routes/userRoutes");
const ReservationRouter = require("./routes/reservationRoutes"); // Add this line
const app = express();

app.use(express.json());
app.use(bodyParser.json());

app.use("/api/seeker", SeekerRouter);
app.use("/api/user", UserRouter);
app.use("/api", ReservationRouter); // Add this line

app.get("/", (req, res) => {
  res.send("Hello Ahzem! I'm a Node.js app!");
});

module.exports = app;
