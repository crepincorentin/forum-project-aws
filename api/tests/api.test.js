import request from "supertest";
import express from "express";
import router from "../src/routes.js";

const app = express();
app.use(express.json());
app.use(router);

describe("API Forum", () => {
  it("GET /messages should return array", async () => {
    const res = await request(app).get("/messages");
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  it("POST /messages should validate input", async () => {
    const res = await request(app)
      .post("/messages")
      .send({ pseudonyme: "", contenu: "" });
    expect(res.statusCode).toBe(400);
  });
});
