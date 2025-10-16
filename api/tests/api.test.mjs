import { jest } from "@jest/globals";

// 🧠 On mocke "pg" avant d'importer le reste
await jest.unstable_mockModule("pg", () => {
  return {
    default: {
      Pool: jest.fn(() => ({
        query: jest.fn(() => Promise.resolve({ rows: [] })),
        connect: jest.fn(),
        end: jest.fn(),
        on: jest.fn(),
      })),
    },
  };
});

// ⏳ Import dynamique après le mock
const { default: express } = await import("express");
const { default: router } = await import("../src/routes.js");
const request = (await import("supertest")).default;

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
