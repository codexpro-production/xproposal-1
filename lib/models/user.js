const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  email: { type: String, required: true },
  password: { type: String, required: true },
  is_active: { type: Boolean, default: false }, // Aktivasyon durumu
});

module.exports = mongoose.model('User', UserSchema);
