const mongoose = require("mongoose");
require("dotenv").config();

const uri = process.env.MONGODB_URI;

mongoose
  .connect(uri)
  .then(() => {
    console.log("Hello Ahzem, I'm connected to MongoDB");
  })
  .catch((error) => {
    console.log("Error connecting to MongoDB", error);
  });

module.exports = mongoose;
