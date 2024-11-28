const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
app.use(bodyParser.json());
app.use(cors());

// MongoDB bağlantısı
const mongoUri = "mongodb+srv://codexpro:l1o5d4weBG6977lm@cluster0.ts0d7.mongodb.net/xproposal?retryWrites=true&w=majority";
mongoose
  .connect(mongoUri, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log("MongoDB'ye bağlandı"))
  .catch((err) => console.error("MongoDB bağlantı hatası:", err));

// Kullanıcı Şeması
const userSchema = new mongoose.Schema({
  type: String,
  name: String,
  surname: String,
  tckn: Number,
  vkn: Number,
  email: String,
  password: String,
});

const User = mongoose.model("User", userSchema);

// API Rotası: Kullanıcı Ekle
app.post("/add-user", async (req, res) => {
  try {
    const user = new User(req.body);
    await user.save();
    res.status(201).send({ success: true, message: "Kullanıcı başarıyla eklendi!" });
  } catch (err) {
    res.status(500).send({ success: false, message: "Kullanıcı eklenemedi!", error: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`API ${PORT} portunda çalışıyor`));
