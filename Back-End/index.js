require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const app = require("./app.js");
require("./config/db.js"); // Ensure the database connection is established

const port = process.env.PORT || 3000;
const host = "0.0.0.0"; // Bind to all network interfaces

app.listen(port, host, () => {
  console.log(`Hi Ahzem, I'm listening on port ${port}!`);
});
