
const express = require('express');
const router = express.Router();
const db = require("../db"); 
const bcrypt = require('bcrypt');

router.get('/profile', (req, res) => {
  const user=req.session.user;
  if (!user) {
    return res.redirect('/login.html'); // Redirect to login if not logged in
  }
  const userId = user.customer_ID;
  const selectOrderQuery = `
  SELECT * 
  FROM orders
  where customer_ID = ? and TOTAL_COST IS NOT NULL;
`;

  db.query(selectOrderQuery, userId, (err, results) => {
   if (err) {
    console.error("Error fetching orders:", err);
    return res.status(500).json({ error: "Error fetching orders." });
   }
   res.render('profile', { user: user, orderHistory: results });
  });
});

router.post('/profile/edit',  async (req, res) => {
  const user=req.session.user;

  if (!user) {
    return res.redirect('/login.html');
  }
  const userId = user.customer_ID; // Get user ID from session
  const hashedPassword = await bcrypt.hash(req.body.password, 10); // 10 is number of salt rounds
  const updatedInfo = [
      req.body.firstName,
      req.body.lastName,
      req.body.email,
      hashedPassword,
      userId
  ];
  const updateUserQuery = `
  UPDATE customers
  SET customer_first_name = ?,
   customer_last_name = ?,
   email = ?,
   password = ?
  where customer_ID = ?
`;
  await db.query(updateUserQuery,updatedInfo, (err,results) => {
    if (err) {
     console.error("Error updating user profile:", err);
     return res.status(500).json({ error: "Error updating user profile." });
    }
    req.session.user.customer_first_name = updatedInfo[0];
    req.session.user.customer_last_name = updatedInfo[1];
    req.session.user.email = updatedInfo[2];
    res.redirect('/profile');
  });
});

  
module.exports = router;
