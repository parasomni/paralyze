const { MongoClient } = require('mongodb');
const uri = "mongodb://localhost:27017";
const client = new MongoClient(uri);
const dbName = "paralyze";

async function getAgents() {
  await client.connect();
  const db = client.db(dbName);
  return await db.collection("agents").find().toArray();
}

module.exports = { getAgents };
