const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const connectToDatabase = require("./services/db");
const userRoutes = require("./routes/userRoutes");

const app = express();

// Middleware
app.use(bodyParser.json());
app.use(cors());

// Routes
app.use("/api", userRoutes);

// Database Connection
connectToDatabase();

// Start Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`API ${PORT} portunda çalışıyor`));
