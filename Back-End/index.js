const app = require("./app");

const port = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.send("Hello Ahzem! I'm a Node.js app!");
});

app.listen(port, () => {
  console.log(`Hi Ahzem, I'm listening on port ${port}!`);
});
