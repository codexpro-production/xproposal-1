const mongoose = require("mongoose");

const userVendorSchema = new mongoose.Schema({
  type: { type: String, required: true },
  name: { type: String, required: true },
  surname: { type: String, required: true },
  tckn: { type: Number, required: true },
  vkn: { type: Number, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
});

const UserVendor = mongoose.model("UserVendor", userVendorSchema);
module.exports = UserVendor;
