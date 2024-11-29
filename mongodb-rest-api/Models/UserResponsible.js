const mongoose = require("mongoose");

const userResponsibleSchema = new mongoose.Schema({
  type: { type: String, required: true },
  name: { type: String, required: true },
  surname: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },

  purchaseGroup: { type: String, required: true },
  telNumber: { type: Number, required: true },
  faxNumber: { type: Number, required: true },
  responsible: { type: Number, required: true },
});

const UserResponsible = mongoose.model("UserResponsible", userResponsibleSchema);
module.exports = UserResponsible;


