const mongoose = require("mongoose");

const userResponsibleSchema = new mongoose.Schema({
  type: { type: String },
  name: { type: String, required: true },
  surname: { type: String, required: true },
  tckn: { type: Number },
  vkn: { type: Number },
  email: { type: String, unique: true, require: true},
  password: { type: String },

  purchaseGroup: { type: String, required: true },
  telNumber: { type: Number, required: true },
  faxNumber: { type: Number, required: true },
  responsible: { type: Number, required: true },

  activationToken: { type: String },
  isActive: {type: Boolean, default: false},
});

const UserResponsible = mongoose.model("UserResponsible", userResponsibleSchema);
module.exports = UserResponsible;


