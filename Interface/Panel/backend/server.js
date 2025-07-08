const express = require('express');
const app = express();
const port = 3000;

const mongo = require('mongodb');
const maria = require('mariadb');

app.use(express.json());
app.use(express.static('public')); // Serve index.html

app.get('/api/agents', async (req, res) => {
  const agents = await mongo.getAgents();
  res.json(agents);
});

app.post('/api/shutdown', async (req, res) => {
  await maria.logShutdownEvent();
  res.sendStatus(200);
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
