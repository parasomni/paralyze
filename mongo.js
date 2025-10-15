const { MongoClient } = require('mongodb');

import fs from 'fs';
import { MongoClient } from 'mongodb';

export async function checkMongoDBConnection() {
  try {
    const configData = fs.readFileSync('config_module.json', 'utf8');
    const config = JSON.parse(configData);
    const uri = config.general.uri;

    const client = new MongoClient(uri, { useUnifiedTopology: true });
    await client.connect();
    await client.db().admin().ping();  
    await client.close();

    return true;
  } catch (err) {
    console.error("MongoDB connection error:", err.message);
    return false;
  }
}
