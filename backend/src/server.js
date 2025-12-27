const express = require("express");
const cors = require("cors");
require("dotenv").config();

const app = express();

// Try to connect to MongoDB, but continue if it fails (development mode)
try {
  const connectDB = require("./config/db");
  connectDB();
} catch (error) {
  console.log("MongoDB connection failed, using mock data for development");
}

app.use(cors());
app.use(express.json());

// Routes
app.use("/api/maintenance", require("./routes/maintenance.routes"));
app.use("/users", require("./routes/user.routes"));

// Health check
app.get("/health", (req, res) => {
  res.json({ status: "Server is running" });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
