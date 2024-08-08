const mongoose = require("mongoose");
require("dotenv").config();

const uri = process.env.MONGODB_URI;

const connection = mongoose
  .createConnection(uri)
  .on("open", () => {
    console.log("Hello Ahzem, I'm connected to MongoDB");
  })
  .on("error", (error) => {
    console.log("Error connecting to MongoDB", error);
  });

// Corrected the typo here
module.exports = connection;
