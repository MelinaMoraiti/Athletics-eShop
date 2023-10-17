const express = require('express');
const db = require("../db");
const router = express.Router();
const path = require('path'); 
const { Console } = require('console');
router.use(express.static(path.join(__dirname, 'public')));

router.get("/shopping_cart_empty", (req, res) => {
  const user=req.session.user;
  res.render('shopping_cart_empty', { user }); 
});

router.get("/shopping_cart", (req, res) => {
    const user=req.session.user;
    if (!user) {
      return res.sendFile(path.join(__dirname, './public/login.html'));
    }
    const existingCartOrderQuery = `
    SELECT order_id
    FROM orders
    WHERE customer_id = ? AND total_cost IS NULL;`;
    db.query(existingCartOrderQuery, user.customer_ID, (err, results) => {
    if (err) {
    console.error("Error fetching products:", err);
    return res.status(500).json({ error: "Error fetching products." });
    }

  let orderId;
  if (results.length > 0) {
    // If an open cart order already exists, use its order_id
    
    orderId = results[0].order_id;
    const query = `
    SELECT oi.*, p.product_name, p.price, p.image_url
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    WHERE order_id = ?`;

    db.query(query, orderId, (err, cartItems) => {
    if (err) 
    {
      return res.status(500).send('Error retrieving cart items.');
    }
    let totalCost = 0;
    cartItems.forEach(item => {
      totalCost += item.price * item.quantity;});
    req.session.orderId = orderId;
    res.render('shopping_cart', { cartItems,user,totalCost });
    });
  } 
  else {
    // If no open cart order exists
    req.session.orderId = orderId;
    res.render('shopping_cart_empty', { user }); 
   }
  });
});

router.post("/checkout", async (req, res) => {
  try {
      const orderId = req.session.orderId; // Retrieve order ID from session
      const newAddress = req.body.address; // Get the new address from the form
  
      const query = `
      SELECT oi.*, p.product_name, p.price
      FROM order_items oi
      JOIN products p ON oi.product_id = p.product_id
      WHERE order_id = ?`;
      db.query(query, orderId, (err, cartItems) => {
        if (err) 
        {
          return res.status(500).send('Error retrieving cart items.');
        }
        let newTotalCost = 0;
        cartItems.forEach(item => {
          newTotalCost += item.price * item.quantity;});
          // Update the orders table with the new address and total cost

          const updateOrderQuery = `
          UPDATE orders
          SET address = ?, total_cost = ?
          WHERE order_id = ?;`;
          db.query(updateOrderQuery, [newAddress, newTotalCost, orderId]);
      });
      
      // Clear the order ID from the session
      delete req.session.orderId;

      res.redirect("/home"); 
  } catch (error) {
      console.error("Error updating order:", error);
      res.status(500).send("Error updating order");
  }
});

router.post("/products/shopping_cart/add-to-cart", (req, res) =>
{
  try {
    const user = req.session.user;
    if (!user) {
      return res.sendFile(path.join(__dirname, '../public/login.html'));
    }
    const customerId = user.customer_ID; // Get the customer's ID from the session
    const productId = parseInt(req.body.product_id); // Get the product ID from the request body
    const quantity = parseInt(req.body.quantity); // Get the quantity from the request body
    // Check if there's an existing open cart order for the customer
    const existingCartOrderQuery = `
        SELECT order_id
        FROM orders
        WHERE customer_id = ? AND total_cost IS NULL;
    `;
     db.query(existingCartOrderQuery, customerId, (err, results) => {
      if (err) {
        console.error("Error fetching products:", err);
        return res.status(500).json({ error: "Error fetching products." });
      }

      let orderId;
      if (results.length > 0) {
        // If an open cart order already exists, use its order_id
        orderId = results[0].order_id;
      } else {
        // If no open cart order exists, create a new order for the customer
        const createOrderQuery = `
            INSERT INTO orders (customer_id, order_date)
            VALUES (?, NOW());`;
         db.query(createOrderQuery, customerId);
         const existingCartOrderQuery = `
        SELECT order_id
        FROM orders
        WHERE customer_id = ? AND total_cost IS NULL;`;
        db.query(existingCartOrderQuery, customerId, (err, results) => {
      if (err) {
        console.error("Error fetching products:", err);
        return res.status(500).json({ error: "Error fetching products." });
      }
        orderId = results[0].order_id;
      }
    )};
     
      // Insert a new order item into the order_items table
      const insertCartItemQuery = `
        INSERT INTO order_items (order_id, product_id, quantity)
        VALUES (?, ?, ?);
    `;
      db.query(insertCartItemQuery, [orderId, productId, quantity]);

      req.session.orderId = orderId;
      res.redirect("/shopping_cart"); // Redirect to the shopping cart page
    });
} catch (error) {
    console.error("Error adding to cart:", error);
    res.status(500).send("Error adding to cart");
}
});

router.post("/remove-from-cart/:productId", async (req, res) => {
  try {
    const orderId = req.session.orderId;
    const productId = req.params.productId;
    
    // Remove the product from the order_items table
    const removeProductQuery = `
      DELETE FROM order_items
      WHERE order_id = ? AND product_id = ?;
    `;
    await db.query(removeProductQuery, [orderId, productId]);
    
    res.redirect("/shopping_cart");
  } catch (error) {
    console.error("Error removing product:", error);
    res.status(500).send("Error removing product");
  }
});

router.post("/update-cart-item/:productId", async (req, res) => {
  try {
    const orderId = req.session.orderId;
    const productId = req.params.productId;
    const newQuantity = parseInt(req.body.quantity);
    
    // Update the quantity of the product in the order_items table
    const updateQuantityQuery = `
      UPDATE order_items
      SET quantity = ?
      WHERE order_id = ? AND product_id = ?;
    `;
    await db.query(updateQuantityQuery, [newQuantity, orderId, productId]);
    
    res.redirect("/shopping_cart");
  } catch (error) {
    console.error("Error updating quantity:", error);
    res.status(500).send("Error updating quantity");
  }
});
module.exports = router;
