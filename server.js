const express = require("express");
const productRoutes = require("./routes/productRoutes.js");
const db = require("./db.js");

const app = express();
const PORT = 8080;

app.use(express.urlencoded({ extended: false }));
app.set("view engine", "pug");

app.use(express.static("static"));

app.use("/products", productRoutes);

app.get("/", (_, res) => res.redirect("/products"));

db.sync({ force: false }).then(() => {
  app.listen(PORT, console.log("Server is running on port: " + PORT));
});
