const express = require("express");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const nodemailer = require("nodemailer");
const UserVendor = require("./models/UserVendor");
const UserResponsible = require("./models/UserResponsible");

const router = express.Router();

// Add User (Vendor or Responsible)
router.post("/add-user", async (req, res) => {
  try {
    const { type, name, surname, tckn, vkn, email, purchaseGroup,
      telNumber,
      faxNumber,
      responsible, } = req.body;

    const existingUser = await UserVendor.findOne({ email }) || await UserResponsible.findOne({ email });
      if (existingUser) {
        return res.status(409).send({ success: false, message: "Bu kullanıcı zaten kayıtlı!" });
      }
  
    const activationToken = jwt.sign({ email }, 'secret-key', { expiresIn: '1h' });

    if (type === "Vendor") {
      const user = new UserVendor({
        type: "Vendor",
        name,
        surname,
        tckn,
        vkn,
        email,
        activationToken, 
        isActive:false 
      });
      await user.save();

      const activationTokenLink = `http://localhost:54334/setup-password#/setup-password?token=${activationToken}`;
      await sendEmail({ email, activationTokenLink });

      res.status(201).send({
        success: true,
        message: `${type} successfully added! Activation link has been sent.`,
        activationTokenLink,
      });
      
    } else if (type === "Responsible") {
      model = UserResponsible;
      const user = new model({
        type: "Responsible",
        name,
        surname,
        tckn,
        vkn,
        email,
        purchaseGroup,
        telNumber,
        faxNumber,
        responsible,
        activationToken, 
        isActive:false 
      });
      await user.save();

      const activationTokenLink = `http://localhost:54334/setup-password#/setup-password?token=${activationToken}`;
      await sendEmail({ email, activationTokenLink });

      res.status(201).send({
        success: true,
        message: `${type} successfully added! Activation link has been sent.`,
        activationTokenLink,
      });
    } else {
      return res.status(400).send({ success: false, message: "Invalid user type!" });
    }
  } catch (err) {
    res.status(500).send({ success: false, message: "User could not be added!", error: err.message });
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
    res.status(500).send({ success: false, message: "Users could not be retrieved!", error: err.message });
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
    res.status(200).send({ success: true, message: "User updated successfully!", user: updatedUser });
  } catch (err) {
    res.status(500).send({ success: false, message: "User could not be updated!", error: err.message });
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
    res.status(200).send({ success: true, message: "User deleted successfully!" });
  } catch (err) {
    res.status(500).send({ success: false, message: "User could not be deleted!", error: err.message });
  }
});
/////////////////////////////////////////////////////////////////
router.post("/setup-password", async (req, res) => {
  const { token, password } = req.body;
  if (!token || !password) {
    return res.status(400).json({ message: "Eksik parametreler" });
}
  try {
    const decoded = jwt.verify(token, 'secret-key');
    let user = await UserVendor.findOne({ activationToken: token });

    if (!user) {
      user = await UserResponsible.findOne({ activationToken: token });
    }
    if (!user) {
      return res.status(400).json({
        success: false,
        message: "Kullanıcı bulunamadı veya geçersiz token",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    user.password = hashedPassword;
    user.activationToken = null; 
    user.isActive = true; 

    await user.save();

    return res.status(200).json({ success: true, message: "Şifre başarıyla sıfırlandı!" });
  } catch (err) {
    if (err.name === "TokenExpiredError") {
      return res.status(400).json({ success: false, message: "Token süresi dolmuş." });
    } else {
      return res.status(500).json({ success: false, message: "Şifre sıfırlama hatası.", error: err.message });
    }
  }
});

router.post("/login", async (req, res) => {
  const { tcVkn, password } = req.body;

  try {

    console.log('Gelen veri:', { tcVkn, password });

    let user = await UserVendor.findOne({ $or: [{ tckn: tcVkn }, { vkn: tcVkn }],  isActive: true});
    console.log('UserVendor sorgu sonucu:', user);
    if (!user) {
      console.log('UserResponsible sorgusu yapılıyor...');
      user = await UserResponsible.findOne({ $or: [{ tckn: tcVkn }, { vkn: tcVkn }], isActive: true });
      console.log('UserResponsible sorgu sonucu:', user);
    }
    console.log('Bulunan kullanıcı:', user);

    if (!user) {
      return res.status(400).send({ success: false, message: "User not found." });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    console.log('Şifre doğrulama sonucu:', isMatch);

    if (!isMatch) {
      return res.status(400).send({ success: false, message: "Incorrect password." });
    }

    res.status(200).send({
      success: true,
      message: "Giriş başarılı!",
    });
  } catch (err) {
    console.error('Hata detayları:', err);
    res.status(500).send({ success: false, message: "Login error.", error: err.message });
  }
});


async function sendEmail({ email, activationTokenLink }) {
  try {
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: 'gun.colak@gmail.com',
        pass: 'bmec rrqr tcki yecv', // APP Password
      },
    });

    const mailOptions = {
      from: 'gun.colak@gmail.com',
      to: email,
      subject: 'Activation Link',
      text: `To activate your account, please click the link below:
            ${activationTokenLink}
            
            This link is valid for 1 hour.`,
    };

    const info = await transporter.sendMail(mailOptions);
    console.log('Email sent:', info.response);
  } catch (error) {
    console.error('Error sending email:', error);
    throw new Error('Could not send email.');
  }
}

module.exports = router;