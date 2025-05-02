const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'tiendamangas',  
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

async function testConnection() {
  try {
    const connection = await pool.getConnection();
    console.log("Conexión MySQL exitosa");
    connection.release();
  } catch (error) {
    console.error("Error en la conexión MySQL:", error);
  }
}

testConnection();

module.exports = pool;