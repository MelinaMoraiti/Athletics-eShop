const express = require('express');
const helmet = require('helmet');
const bodyParser = require('body-parser');
require('dotenv').config();
const session = require('express-session');
const path = require('path'); // Import the 'path' module
const app = express();

// Use Helmet middleware for security headers
app.use(helmet.noSniff());
app.use(helmet.xssFilter());
app.use(helmet.frameguard({ action: 'deny' }));

const authRouter = require('./routes/auth'); // Import auth routes
const profileRouter = require('./routes/profile'); // Import profile routes
const productsRouter = require('./routes/products'); // Import products routes
const cartRouter = require('./routes/shopping_cart'); //
const adminRouter = require('./routes/admin'); 

// Middleware setup
app.use(bodyParser.urlencoded({ extended: true }));
app.use(session({ secret: 'key', resave: false, saveUninitialized: true }));
app.set('view engine', 'ejs');
//app.set('views', path.join(__dirname, 'views')); 
// Use the routes
app.use('/',adminRouter);
app.use('/',cartRouter);
app.use('/', authRouter); // Routes defined in auth.js
app.use('/', profileRouter); // Routes defined in profile.js
app.use('/products',productsRouter);// Routes defined in products.js
app.use(express.static(path.join(__dirname, 'public')));

app.get("/", (req, res) => {
  const user=req.session.user;
  res.render("home", { title: 'Home', user: user });
  //res.sendFile(path.join(__dirname, 'public/home.html'));
});
app.get("/home", (req, res) => {
  const user=req.session.user;
  res.render("home", { title: "Home", user: user }); // Pass the user variable
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, 'localhost', () => {
  console.log(`Server is running at http://localhost:${PORT}/`);
});