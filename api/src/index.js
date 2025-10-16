import express from "express";
import bodyParser from "body-parser";
import dotenv from "dotenv";
import router from "./routes.js";
import { pool } from "./db.js";
import cors from "cors";

dotenv.config();

const app = express();

// ✅ Autoriser le front à accéder à l'API
// En production, l'origine est définie par variable d'environnement
// Si CORS_ORIGIN="*", accepte toutes les origines (pour MVP)
const allowedOrigins = process.env.CORS_ORIGIN
  ? process.env.CORS_ORIGIN === "*"
    ? "*"
    : process.env.CORS_ORIGIN.split(",")
  : ["http://localhost:8080"];

app.use(
  cors({
    origin: allowedOrigins,
    methods: ["GET", "POST"],
  }),
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

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 API running on port ${PORT}`);
});
