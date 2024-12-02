const mongoose = require("mongoose");

const userVendorSchema = new mongoose.Schema({
  type: { type: String },
  name: { type: String, required: true },
  surname: { type: String, required: true },
  tckn: { type: Number },
  vkn: { type: Number },
  email: { type: String },
  password: { type: String },
  activationToken: { type: String },
  isActive: {type: Boolean, default: false},
});

const UserVendor = mongoose.model("UserVendor", userVendorSchema);
module.exports = UserVendor;
