const express = require('express');
const connectDB = require('./db');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Connect to MongoDB
connectDB();

// Define a schema
const Schema = new mongoose.Schema({
  purchaseGroup: String,
  purchaseGroupText: String,
  telNumber: Number,
  faxNumber: Number,
  responsible: Number,
  email: String,
  password: String,
});

const Collection = mongoose.model('Collection', Schema);

// CRUD Routes
app.post('/documents', async (req, res) => {
  try {
    const document = new Collection(req.body);
    await document.save();
    res.status(201).json({ message: 'Document created successfully', document });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/documents', async (req, res) => {
  try {
    const documents = await Collection.find();
    res.status(200).json(documents);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/documents/:id', async (req, res) => {
  try {
    const document = await Collection.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.status(200).json({ message: 'Document updated successfully', document });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/documents/:id', async (req, res) => {
  try {
    await Collection.findByIdAndDelete(req.params.id);
    res.status(200).json({ message: 'Document deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Start server
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
