require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const app = express();
require("./config/db.js"); // Ensure the database connection is established

app.use(bodyParser.json());

const seekerController = require("./controllers/seekerController");

app.get("/", (req, res) => {
  res.send("Hello Ahzem! Welcome to the Seeker API!");
});

app.post("/register", seekerController.registerSeeker);

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`Hi Ahzem, I'm listening on port ${port}!`);
});
