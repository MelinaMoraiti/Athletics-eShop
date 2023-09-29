// routes/auth.js
const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const db = require("../public/scripts/db"); // Make sure the relative path is correct
const bodyParser = require('body-parser');
const session = require('express-session');
const path = require('path'); // Import the 'path' module

router.use(express.static(path.join(__dirname, 'public')));

router.post('/signup',   (req, res) => {
    const firstName = req.body['first-name'];
    const lastName = req.body['last-name'];
    const email = req.body.email;
    const password = req.body['new-password'];
    const age  = req.body.age;
    const accountType = req.body['account-type'];
  
    // Hash the password
    bcrypt.hash(password, 10, (err, hashedPassword) => {
      if (err) {
        console.error('Error hashing password:', err);
        return res.status(500).json({ error: 'Error hashing password' });
      }
    // Insert data into the 'customers' table
    const sql = 'INSERT INTO customers (customer_first_name, customer_last_name, email, password) VALUES (?, ?, ?, ?)';
    const values = [firstName, lastName, email, hashedPassword];
  
    // Store user data in the session
    req.session.firstName = firstName;
    req.session.lastName = lastName;
    req.session.email = email;
    req.session.age = age;
    req.session.accountType = accountType;
  
     db.query(sql, values, (error, results) => {
      if (error) {
        console.error('Error inserting data:', error);
        return res.status(500).json({ error: 'Error inserting data' });
      }
  
      res.redirect('/profile');
    });
   });
  });


router.post('/login',  (req,res) =>
{
   const emailInput = req.body['email'];
   const passwordInput = req.body['password'];
   // Show customers with the email that was input in the form
   const sqlQuery ='SELECT * FROM CUSTOMERS WHERE email=? ';
    db.query(sqlQuery,emailInput,(error,results) => {
       if (error){
        console.error("Error Querying database ",error)
        return res.status(500).json({error:'Server Error'});
       }
       if(results.length === 0) {
        return res.status(500).json({error:'Invalid Credentials'});
       }
    //Emails are unique
    const user = results[0]; //User with the input email
    //Comparing the input password with the hashed password in database
    bcrypt.compare(passwordInput,user.password,(bcryptErr,isMatch) =>{
      if(bcryptErr)
      {
        console.error("Error Querying database ",error)
        return res.status(500).json({error:'Server Error'});
      }
      if(!isMatch)
      {
        return res.status(500).json({error:'Invalid Credentials'});
      }
    // Store user data in the session
    req.session.id = user.customer_ID;
    req.session.firstName = user.customer_first_name;
    req.session.lastName = user.customer_last_name;
    req.session.email = user.email;

    req.session.user = user;
    res.redirect('/profile');
    });
   });
});

router.get("/login", (req, res) => {
  //res.render("login", { title: "Login" });   login view (login.ejs)
  res.sendFile(path.join( __dirname,'../public', 'login.html')); //(static file html)
});

router.get('/logout', (req, res) => {
  req.session.user = null;
  // Clear user session data
  req.session.destroy(err => {
    if (err) {
      console.error('Error destroying session:', err);
    }
    // Redirect to the homepage 
    res.redirect('/');
  });
});
module.exports = router;