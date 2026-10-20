// Node.js Express REST API Core Engine

const express = require("express");

const { Pool } = require("pg");

const http = require("http");

const { Server } = require("socket.io");

const app = express();

const server = http.createServer(app);

const io = new Server(server, { cors: { origin: "*" } });

app.use(express.json());

// PostgreSQL Connection Pool

const pool = new Pool({
  connectionString:
    process.env.DATABASE_URL ||
    "postgres://postgres:postgres@localhost:5432/farmsetu",
});

// PostGIS Radius Search Endpoint

app.get("/api/v1/crops/search", async (req, res) => {
  try {
    const { lat, lng, radius_km = 50 } = req.query;

    const query = `

      SELECT l.id, l.crop_name, l.category, l.quantity_kg, l.price_per_kg,

             ST_Distance(f.location, ST_MakePoint($1, $2)::geography) / 1000 AS distance_km

      FROM crop_listings l

      JOIN farmer_profiles f ON l.farmer_id = f.user_id

      WHERE l.status = 'AVAILABLE'

        AND ST_DWithin(f.location, ST_MakePoint($1, $2)::geography, $3 * 1000)

      ORDER BY distance_km ASC;

    `;

    const { rows } = await pool.query(query, [
      parseFloat(lng),
      parseFloat(lat),
      parseFloat(radius_km),
    ]);

    res.json({ success: true, count: rows.length, data: rows });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// Socket.io Dynamic Bidding Room

io.on("connection", (socket) => {
  socket.on("join_bidding_room", ({ listingId }) => {
    socket.join(`order_room_${listingId}`);
  });

  socket.on("place_bid", ({ listingId, buyerId, bidAmount }) => {
    io.to(`order_room_${listingId}`).emit("new_bid_update", {
      buyerId,
      bidAmount,
      timestamp: new Date(),
    });
  });
});

const PORT = process.env.PORT || 5000;

server.listen(PORT, () =>
  console.log(`FarmSetu Core Service running on port ${PORT}`),
);
