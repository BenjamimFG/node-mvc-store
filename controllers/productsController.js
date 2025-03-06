const Product = require("../models/Product");

const renderNewWithError = (error) => {
  return res.render("new", { error });
};

module.exports = {
  index: async (req, res) => {
    const products = await Product.findAll();

    res.render("index", { products });
  },

  new: (req, res) => {
    res.render("new");
  },

  create: async (req, res) => {
    const { name, imageUrl, price } = req.body;

    if (!name || name.length === 0)
      return renderNewWithError("Nome do produto é obrigatório");

    if (!price) return renderNewWithError("Preço do produto é obrigatório");

    if (price <= 0)
      return renderNewWithError("Preço do produto deve ser positivo");

    await Product.create({
      name,
      price,
      imageUrl: imageUrl?.length > 0 ? imageUrl : null,
    });

    res.redirect("/products");
  },
};
