const dotenv = require("dotenv");
const express = require("express");
const app = express();

dotenv.config();
const PORT = 3000;

app.get("/", (req, res) => {
  res.send("Hello, Node.js on Docker 🚀");
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
