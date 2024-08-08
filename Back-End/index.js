require("dotenv").config();
const app = require("./app");
const db = require("./config/db");
const SeekerModel = require("./models/seekerModel");

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`Hi Ahzem, I'm listening on port ${port}!`);
});
