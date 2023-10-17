const express = require('express');
const db = require("../db");
const router = express.Router();

router.get("/:category", (req, res) => {
    const page = req.query.page || 1;
    const productsPerPage = 10;
    const startIdx = (page - 1) * productsPerPage;
    const categoryName = req.params.category;
  
    const query = `
      SELECT * 
      FROM products 
      WHERE category_id = 
            (SELECT category_id from categories
            where category_name= ?) 
      LIMIT ?, ?
    `;
    
    db.query(query, [categoryName, startIdx, productsPerPage], (err, results) => {
      if (err) {
        console.error("Error fetching products:", err);
        return res.status(500).json({ error: "Error fetching products." });
      }
      
      const user=req.session.user;
      res.render("products", { category: categoryName, products: results, user: user });
    });
  });
module.exports = router;
