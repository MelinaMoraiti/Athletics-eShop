
const mysql = require("mysql");

// Create a MySQL connection pool
const db = mysql.createPool({
  host: "127.0.0.1",
  user: "root",
  password: "",
  database: "sports_eshop",
  connectionLimit: 10 // Adjust as needed
});

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