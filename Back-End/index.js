require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const app = require("./app.js");
require("./config/db.js"); // Ensure the database connection is established

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`Hi Ahzem, I'm listening on port ${port}!`);
});
