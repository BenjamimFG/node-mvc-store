const express = require("express");
const productsController = require("../controllers/productsController");

const router = express.Router();

router.get("/", productsController.index);
router.get("/new", productsController.new);

router.post("/", productsController.create);

module.exports = router;
