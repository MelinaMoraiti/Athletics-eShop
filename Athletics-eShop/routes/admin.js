const express = require('express');
const db = require("../db");
const router = express.Router();

const isAdmin = (req, res, next) => {
    if (req.session.email === 'admin@admin.com') {
        return next(); // Proceed to next middleware or route handler
    }
    res.redirect('/login');
};

// Product management page
router.get('/admin', isAdmin, async (req, res) => {
    const query = `
    SELECT * 
    FROM products 
    
  `;
  
  await db.query(query, (err, results) => {
    if (err) {
      console.error("Error fetching products:", err);
      return res.status(500).json({ error: "Error fetching products." });
    }
    
    const user=req.session.user;
    res.render("admin", {  products: results, user: user });
  });

});

// Add new product/user form
router.get('/admin/add-product', isAdmin, (req, res) => {
  res.redirect('/admin');
});

function findCategoryId(categoryName)
{
  return new Promise((resolve, reject) => {
   const query =`select category_id from categories
                 where category_name = ? `;
  db.query(query, categoryName, (err, results) => {
    if (err) {
        console.error("Error fetching catehory ID:", err);
        reject(err);
    }
    else{
      resolve(results[0].category_id);
    }
  });
});
}
// Handle  addition
router.post('/admin/add-product', isAdmin,async (req, res) => {
    const categoryName = req.body.category;
    console.log(categoryName);
    try {
    const categoryId = await findCategoryId(categoryName);
    const productName = req.body.product_name;
    const price = parseFloat(req.body.price);
    const description = req.body.description;
    const imageUrl = req.body.image_url;
    const values =[categoryId,productName,price,description,imageUrl];
    const insertProductQuery = "INSERT INTO PRODUCTS (category_id,product_name,price,description,image_url) VALUES (?,?,?,?,?)";
    
    await db.query(insertProductQuery, values, (error, results) => {
      if (error) {
        console.error('Error inserting data:', error);
        return res.status(500).json({ error: 'Error inserting data' });
      }
  
      res.redirect('/admin');
    });
    }
    catch (error){
      console.error("Error:", error);
      return res.status(500).json({ error: "Error fetching category ID." });
    }
});

function fetchProductById(productId)
{
  return new Promise((resolve, reject) => {
   const query =`select * from products
                 where product_id = ? `;
  db.query(query, productId, (err, results) => {
    if (err) {
        console.error("Error fetching products:", err);
        reject(err);
    }
    else{
      resolve(results[0]);
    }
  });
});
}
// Edit form
router.get('/admin/edit/:id', isAdmin, async (req, res) => {
  try {
    const product_id = req.params.id;
    const product = await fetchProductById(product_id);
    if (!product) {
        return res.status(404).send("Product not found");
    }

    const user=req.session.user;
    res.render('editProduct', { product_id, product,user });
} catch (error) {
    console.error("Error:", error);
    return res.status(500).json({ error: "Error fetching product." });
}
});

// Handle  editing
router.post('/admin/edit/:id', isAdmin, async (req, res) => {
    const product_id = req.params.id;
    const { name, price, description } = req.body;

    // Construct the SQL query to update the product details
    const query = `UPDATE products
                   SET product_name = ?, price = ?, description = ?
                   WHERE product_id = ?`;

    // Execute the SQL query
    await db.query(query, [name, price, description, product_id], (err, results) => {
        if (err) {
            console.error("Error updating product:", err);
            return res.status(500).json({ error: "Error updating product." });
        }
        
        // Redirect to a success page or the product details page
        return res.redirect('/admin');
    });
});

// Delete product
router.get('/admin/delete-product/:id', isAdmin, (req, res) => {
    const product_id = req.params.id;
    const query = `
    DELETE 
    FROM products 
    where product_ID = ?
  `;
  
  db.query(query, product_id,(err,results) => {
    if (err) {
      console.error("Error fetching products:", err);
      return res.status(500).json({ error: "Error fetching products." });
    }
    
    const user=req.session.user;
    res.redirect('/admin');
  });
});

module.exports = router;
