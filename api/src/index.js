import express from "express";
import bodyParser from "body-parser";
import dotenv from "dotenv";
import router from "./routes.js";
import { pool } from "./db.js";
import cors from "cors";

dotenv.config();

const app = express();

// ✅ Autoriser le front à accéder à l'API
app.use(
  cors({
    origin: ["http://localhost:8080"], // autorise ton front local
    methods: ["GET", "POST"],
  })
);

app.use(bodyParser.json());
app.use(router);

// Crée la table si besoin
const createTable = async () => {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS messages (
      id SERIAL PRIMARY KEY,
      pseudonyme VARCHAR(50),
      contenu TEXT,
      created_at TIMESTAMP DEFAULT NOW()
    );
  `);
  console.log("✅ Table 'messages' vérifiée/créée");
};

createTable();

app.listen(process.env.PORT, () => {
  console.log(`🚀 API running on port ${process.env.PORT}`);
});
