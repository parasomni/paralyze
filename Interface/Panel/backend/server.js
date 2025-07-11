const express = require('express');
const fs = require('fs');
const path = require('path');

const mariadb = require('mariadb');
const { MongoClient } = require('mongodb');

const app = express();
const PORT = 3000;

app.use(express.json());
app.use(express.static('.'));

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

// server.js (add or replace your existing /api/save-instruction-json route)

app.post('/api/save-instruction-json', express.json(), (req, res) => {
  const { filename, content } = req.body;

  // 1) Strict filename check: no slashes, only alphanumeric, hyphens, underscores, and .json
  const FN_RE = /^[A-Za-z0-9_-]+\.json$/;
  if (!filename || !FN_RE.test(filename)) {
    return res.status(400).json({ success: false, error: 'Invalid filename' });
  }

  // 2) Load interface_settings.conf
  let instrPath;
  try {
    const raw = fs.readFileSync(path.join(__dirname, 'interface_settings.conf'), 'utf8');
    const cfg = raw.split(/\r?\n/).reduce((o, line) => {
      const [k,v] = line.split('=');
      if (k && v) o[k.trim()] = v.trim();
      return o;
    }, {});
    instrPath = cfg.instructions_path;
  } catch (err) {
    console.error('Failed to read interface_settings.conf', err);
    return res.status(500).json({ success: false, error: 'Server configuration error' });
  }

  if (!instrPath) {
    return res.status(500).json({ success: false, error: 'instructions_path not set' });
  }

  // 3) Build absolute directory, ensure it exists
  const baseDir = path.isAbsolute(instrPath)
    ? instrPath
    : path.join(__dirname, instrPath);
  try {
    fs.mkdirSync(baseDir, { recursive: true });
  } catch (err) {
    console.error('Failed to create instructions directory', err);
    return res.status(500).json({ success: false, error: 'Cannot access instructions directory' });
  }

  // 4) Compose the full path, normalize, then verify no traversal
  const fullPath = path.normalize(path.join(baseDir, filename));
  if (!fullPath.startsWith(path.normalize(baseDir + path.sep))) {
    return res.status(400).json({ success: false, error: 'Path traversal detected' });
  }

  // 5) Write the file
  try {
    fs.writeFileSync(fullPath, content, 'utf8');
    return res.json({ success: true, path: fullPath });
  } catch (err) {
    console.error('Error saving JSON file:', err);
    return res.status(500).json({ success: false, error: 'Failed to save file' });
  }
});

app.post('/api/instructions', express.json(), (req, res) => {
  const instructions = req.body.instructions ?? req.body;  
  console.log('Received instructions:', instructions);

  // 1) Load instructions_path from interface_settings.conf
  let instrPath;
  try {
    const raw = fs.readFileSync(
      path.join(__dirname, 'interface_settings.conf'),
      'utf8'
    );
    const cfg = raw.split(/\r?\n/).reduce((o, line) => {
      const [k, v] = line.split('=');
      if (k && v) o[k.trim()] = v.trim();
      return o;
    }, {});
    instrPath = cfg.instructions_path;
    if (!instrPath) throw new Error('instructions_path not set in config');
  } catch (err) {
    console.error('Could not read interface_settings.conf:', err);
    return res.status(500).json({ success: false, error: err.message });
  }

  // 2) Resolve base directory and ensure it exists
  const baseDir = path.isAbsolute(instrPath)
    ? instrPath
    : path.join(__dirname, instrPath);
  try {
    fs.mkdirSync(baseDir, { recursive: true });
  } catch (err) {
    console.error('Failed to create instructions directory:', err);
    return res
      .status(500)
      .json({ success: false, error: 'Cannot access instructions directory' });
  }

  // 3) Map instruction keys → filenames
  const fileMap = {
    dos:         'dos_instructions.json',
    init:        'init_instructions.json',
    proxy:       'proxy_instructions.json',
    maintenance: 'maintenance_instructions.json'
  };

  // 4) Write each block to its own file
  try {
    for (const [key, data] of Object.entries(instructions)) {
      const filename = fileMap[key];
      if (!filename) continue;  // skip unknown keys
      const fullPath = path.join(baseDir, filename);
      fs.writeFileSync(fullPath, JSON.stringify(data, null, 2), 'utf8');
      console.log(`Saved ${key} instructions to ${fullPath}`);
    }
    return res.json({ success: true });
  } catch (err) {
    console.error('Error saving instruction files:', err);
    return res
      .status(500)
      .json({ success: false, error: 'Failed to save instruction files' });
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
