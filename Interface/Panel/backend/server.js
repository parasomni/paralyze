const express = require('express');
const fs = require('fs');
const path = require('path');

const mariadb = require('mariadb');
const { MongoClient } = require('mongodb');

const app = express();
const PORT = 3000;

app.use(express.json());
app.use(express.static('public'));

// Load MariaDB config from db_controller.conf
function loadMariaConfig() {
  const config = {};
  const lines = fs.readFileSync('/home/xpr/repos/wyvern/configs/db_controller.conf', 'utf8').split('\n');
  for (const line of lines) {
    const [key, value] = line.trim().split('=');
    if (key && value) config[key] = value;
  }
  return config;
}

// Load MongoDB config from mongo_controller.conf
function loadMongoConfig() {
  const content = fs.readFileSync('/home/xpr/repos/wyvern/configs/config_module.json', 'utf8');
  return JSON.parse(content);
}

// API route to check both DB statuses
app.get('/api/status/db', async (req, res) => {
  let mariadbOK = false;
  let mongodbOK = false;

  // Check MariaDB
  try {
    const cfg = loadMariaConfig();
    const conn = await mariadb.createConnection({
      host: cfg.server,
      port: parseInt(cfg.port),
      user: cfg.user,
      password: cfg.password,
      database: cfg.database
    });
    await conn.query('SELECT 1');
    mariadbOK = true;
    await conn.end();
  } catch (err) {
    console.error('MariaDB error:', err.message);
  }

  // Check MongoDB
  try {
    const mcfg = loadMongoConfig();
    const mongo = new MongoClient(mcfg.general.uri);
    await mongo.connect();
    await mongo.db().admin().ping();
    mongodbOK = true;
    await mongo.close();
  } catch (err) {
    console.error('MongoDB error:', err.message);
  }

  res.json({ mariadb: mariadbOK, mongodb: mongodbOK });
});

app.get('/api/status/c2', async (req, res) => {
  let isC2Online = false;
  try {
    const c2Config = JSON.parse(fs.readFileSync('/home/xpr/repos/wyvern/configs/control_server.json', 'utf8'));
    const address = c2Config.general.server.address;
    const port = c2Config.general.server.port;

    const net = require('net');
    const socket = new net.Socket();

    const timeout = 2000; // ms
    await new Promise((resolve, reject) => {
      socket.setTimeout(timeout);
      socket.once('error', reject);
      socket.once('timeout', reject);
      socket.connect(port, address, () => {
        isC2Online = true;
        socket.end();
        resolve();
      });
    });
  } catch (err) {
    console.error('C2 connection error:', err.message);
  }
  res.json({ c2: isC2Online });
});

app.post('/api/save-instruction-json', (req, res) => {
  const { path: filePath, json } = req.body;

  try {
    const fullPath = path.join(__dirname, filePath);
    fs.writeFileSync(fullPath, json, 'utf-8');
    res.send("File saved to: " + filePath);
  } catch (err) {
    console.error("Error saving JSON file:", err);
    res.status(500).send("Failed to save JSON.");
  }
});

app.post('/save-settings', express.json(), (req, res) => {
  const settings = req.body;

  const filePath = path.join(__dirname, 'interface_settings.conf');

  let configLines = '';
  for (const [key, value] of Object.entries(settings)) {
      configLines += `${key}=${value}\n`;
  }

  fs.writeFile(filePath, configLines, 'utf8', (err) => {
      if (err) {
          console.error('Error saving settings:', err);
          return res.status(500).json({ success: false, message: 'Failed to save settings.' });
      }

      res.status(200).json({ success: true, message: 'Settings saved successfully.' });
  });
});

app.get('/get-instruction-path', (req, res) => {
  const filePath = path.join(__dirname, 'interface_settings.conf');

  fs.readFile(filePath, 'utf8', (err, data) => {
      if (err) return res.status(500).json({ error: 'Failed to read settings.' });

      const lines = data.split('\n');
      const config = {};
      for (const line of lines) {
          const [key, value] = line.split('=');
          if (key && value) config[key.trim()] = value.trim();
      }

      res.json({ instructions_path: config.instructions_path });
  });
});

// Example API (optional)
app.post('/api/shutdown', async (req, res) => {
  console.log("Shutdown requested");
  res.sendStatus(200);
});

app.listen(PORT, () => {
  console.log(`🚀 Server running at http://localhost:${PORT}`);
});
