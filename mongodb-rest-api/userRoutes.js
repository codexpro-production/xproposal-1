const express = require("express");
const UserVendor = require("../models/UserVendor");
const UserResponsible = require("../models/UserResponsible");

const router = express.Router();

// Add User (Vendor or Responsible)
router.post("/add-user", async (req, res) => {
  try {
    const { type, ...userData } = req.body;

    let model;
    // Check the user type to use the correct model
    if (type === "Vendor") {
      model = UserVendor;
      // Add specific fields for Vendor
      if (!userData.tckn || !userData.vkn) {
        return res.status(400).send({ success: false, message: "Vendor fields missing!" });
      }
    } else if (type === "Responsible") {
      model = UserResponsible;
      // Add specific fields for Responsible
      if (!userData.purchaseGroup || !userData.telNumber || !userData.responsible) {
        return res.status(400).send({ success: false, message: "Responsible fields missing!" });
      }
    } else {
      return res.status(400).send({ success: false, message: "Invalid user type!" });
    }

    // Create and save user
    const user = new model(userData);
    await user.save();
    res.status(201).send({ success: true, message: `${type} başarıyla eklendi!` });
  } catch (err) {
    res.status(500).send({ success: false, message: "Kullanıcı eklenemedi!", error: err.message });
  }
});

// Get all users (Vendor or Responsible)
router.get("/get-users/:type", async (req, res) => {
  try {
    const { type } = req.params;
    let model;
    if (type === "Vendor") {
      model = UserVendor;
    } else if (type === "Responsible") {
      model = UserResponsible;
    } else {
      return res.status(400).send({ success: false, message: "Invalid user type!" });
    }

    const users = await model.find();
    res.status(200).send({ success: true, users });
  } catch (err) {
    res.status(500).send({ success: false, message: "Kullanıcılar getirilemedi!", error: err.message });
  }
});

// Update User (Vendor or Responsible)
router.put("/update-user/:type/:id", async (req, res) => {
  try {
    const { type, id } = req.params;
    const { ...userData } = req.body;

    let model;
    if (type === "Vendor") {
      model = UserVendor;
    } else if (type === "Responsible") {
      model = UserResponsible;
    } else {
      return res.status(400).send({ success: false, message: "Invalid user type!" });
    }

    const updatedUser = await model.findByIdAndUpdate(id, userData, { new: true });
    res.status(200).send({ success: true, message: "Kullanıcı başarıyla güncellendi!", user: updatedUser });
  } catch (err) {
    res.status(500).send({ success: false, message: "Kullanıcı güncellenemedi!", error: err.message });
  }
});

// Delete User (Vendor or Responsible)
router.delete("/delete-user/:type/:id", async (req, res) => {
  try {
    const { type, id } = req.params;

    let model;
    if (type === "Vendor") {
      model = UserVendor;
    } else if (type === "Responsible") {
      model = UserResponsible;
    } else {
      return res.status(400).send({ success: false, message: "Invalid user type!" });
    }

    await model.findByIdAndDelete(id);
    res.status(200).send({ success: true, message: "Kullanıcı başarıyla silindi!" });
  } catch (err) {
    res.status(500).send({ success: false, message: "Kullanıcı silinemedi!", error: err.message });
  }
});

module.exports = router;
