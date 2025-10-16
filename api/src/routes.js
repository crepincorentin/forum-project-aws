import express from "express";
import { pool } from "./db.js";

const router = express.Router();

// GET - Liste des messages
router.get("/messages", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM messages ORDER BY created_at DESC",
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Erreur serveur" });
  }
});

// POST - Ajouter un message
router.post("/messages", async (req, res) => {
  const { pseudonyme, contenu } = req.body;
  if (!pseudonyme || !contenu)
    return res.status(400).json({ error: "Champs manquants" });

  try {
    await pool.query(
      "INSERT INTO messages (pseudonyme, contenu) VALUES ($1, $2)",
      [pseudonyme, contenu],
    );
    res.status(201).json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Erreur serveur" });
  }
});

export default router;
