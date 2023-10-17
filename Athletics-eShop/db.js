const mysql = require("mysql");
require('dotenv').config();
const config = require('./config');
const db = mysql.createPool(config.db);

// Test the database connection
db.getConnection((err, connection) => {
  if (err) {
    console.error("Database connection failed:", err);
  } else {
    console.log("Database connected!");
    connection.release();
  }
});

module.exports = db;