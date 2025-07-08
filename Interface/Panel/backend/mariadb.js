const mariadb = require('mariadb');
const pool = mariadb.createPool({
  host: 'localhost',
  user: 'youruser',
  password: 'yourpass',
  database: 'paralyze'
});

async function logShutdownEvent() {
  const conn = await pool.getConnection();
  await conn.query("INSERT INTO events (type) VALUES ('shutdown')");
  conn.release();
}

module.exports = { logShutdownEvent };
