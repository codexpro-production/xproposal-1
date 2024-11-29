const mongoose = require("mongoose");

const connectToDatabase = async () => {
  const mongoUri = "mongodb+srv://codexpro:l1o5d4weBG6977lm@cluster0.ts0d7.mongodb.net/xproposal?retryWrites=true&w=majority";
  try {
    await mongoose.connect(mongoUri, { useNewUrlParser: true, useUnifiedTopology: true });
    console.log("MongoDB'ye başarıyla bağlandı");
  } catch (err) {
    console.error("MongoDB bağlantı hatası:", err);
    throw err;
  }
};

module.exports = connectToDatabase;
