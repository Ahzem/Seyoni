const express = require("express");
const { connectToDatabase } = require("./config/db");

const app = express();

// Connect to the database before starting the server
connectToDatabase().catch((error) => {
  console.error("Failed to connect to the database", error);
  process.exit(1); // Exit the process with an error code
});

module.exports = app;
