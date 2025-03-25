const express = require("express");

const app = express();

app.get("/", function(req, res) {
  res.set("Content-Type", "text/html");
  res.status(200).send("<h1>Hello World</h1>");
});

app.listen(4000, () => {
  console.log("Now listening to port: 4000");
});
