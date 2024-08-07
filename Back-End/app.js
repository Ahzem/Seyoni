const express = require("express");
const { connectToDatabase } = require("./config/db.js");
const authRouter = require("./routers/authRouter");
const bodyParser = require("body-parser");
require("dotenv").config();

const app = express();

app.use(bodyParser.json());

// Connect to the database before starting the server
connectToDatabase().catch((error) => {
  console.error("Failed to connect to the database", error);
  process.exit(1); // Exit the process with an error code
});

app.use("/api/auth", authRouter);

module.exports = app;
