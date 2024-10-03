const express = require("express");
const bodyParser = require("body-parser");
const SeekerRouter = require("./routes/seekerRoutes");
const UserRouter = require("./routes/userRoutes");
const app = express();

app.use(express.json());
app.use(bodyParser.json());

app.use("/api/seeker", SeekerRouter);
app.use("/api/user", UserRouter);

app.get("/", (req, res) => {
  res.send("Hello Ahzem! I'm a Node.js app!");
});

module.exports = app;
