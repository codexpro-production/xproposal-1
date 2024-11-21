import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
// import '../services/sap_service.dart'; // SAP servis importunu geçici olarak yorum satırı haline getirdik

class PasswordSetupScreen extends StatefulWidget {
  @override
  _PasswordSetupScreenState createState() => _PasswordSetupScreenState();
}

class _PasswordSetupScreenState extends State<PasswordSetupScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLengthValid = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_validatePassword);
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Şifre doğrulama fonksiyonu
  void _validatePassword() {
    final password = _newPasswordController.text;
    setState(() {
      _isLengthValid = password.length >= 8 && password.length <= 12;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasDigit = password.contains(RegExp(r'\d'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  // Şifre görünürlüğünü değiştirme fonksiyonu
  void _togglePasswordVisibility(bool isNewPasswordField) {
    setState(() {
      if (isNewPasswordField) {
        _showNewPassword = true;
        Timer(Duration(seconds: 2), () {
          setState(() => _showNewPassword = false);
        });
      } else {
        _showConfirmPassword = true;
        Timer(Duration(seconds: 2), () {
          setState(() => _showConfirmPassword = false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Şifre Belirleme")),
      body: Center(
        child: Container(
          width: 400,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Şifre gereksinimlerini listele
              _buildRequirementRow("8-12 karakter uzunluğunda", _isLengthValid),
              _buildRequirementRow("En az bir büyük harf (A-Z)", _hasUppercase),
              _buildRequirementRow("En az bir küçük harf (a-z)", _hasLowercase),
              _buildRequirementRow("En az bir sayı (0-9)", _hasDigit),
              _buildRequirementRow("En az bir özel karakter (!, @, #, vb.)", _hasSpecialChar),
              SizedBox(height: 16),

              // Şifre ve şifre tekrar alanları
              _buildPasswordField("Yeni Şifre", _newPasswordController, _showNewPassword, true),
              _buildPasswordField("Şifre Tekrarı", _confirmPasswordController, _showConfirmPassword, false),
              SizedBox(height: 16),

              // Şifre Kaydet butonu
              ElevatedButton(
                onPressed: _setupPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent, // Buton arka plan rengi
                  foregroundColor: Colors.white,       // Buton metin rengi
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Yuvarlak köşe
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14), // İç boşluk
                ),
                child: Text("Şifreyi Kaydet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Gereksinimleri gösteren widget
  Widget _buildRequirementRow(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Yuvarlak işaret (onaylı ya da reddedilmiş)
          CircleAvatar(
            radius: 12,
            backgroundColor: isValid ? Colors.green : Colors.red,
            child: Icon(
              isValid ? Icons.check : Icons.close,
              color: Colors.white,
              size: 16,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Şifre alanı için input widget'ı
  Widget _buildPasswordField(String label, TextEditingController controller, bool isVisible, bool isNewPasswordField) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () => _togglePasswordVisibility(isNewPasswordField),
        ),
      ),
      obscureText: !isVisible,
      obscuringCharacter: '*',
    );
  }

  // Şifreyi hashleme fonksiyonu
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hashed = sha256.convert(bytes);
    return hashed.toString();
  }

  // Şifreyi ayarlama fonksiyonu
  void _setupPassword() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Yeni şifre ya da şifre tekrarının boş olup olmadığını kontrol et
    if (newPassword.isEmpty) {
      setState(() => _errorMessage = "Yeni şifreyi girin");
      return;
    }
    if (confirmPassword.isEmpty) {
      setState(() => _errorMessage = "Şifre tekrarını yapınız");
      return;
    }

    // Şifre gereksinimlerini kontrol et
    if (!(_isLengthValid && _hasUppercase && _hasLowercase && _hasDigit && _hasSpecialChar)) {
      setState(() => _errorMessage = "Lütfen tüm şifre gereksinimlerini sağlayın!");
      return;
    }

    // Şifrelerin uyuşup uyuşmadığını kontrol et
    if (newPassword != confirmPassword) {
      setState(() => _errorMessage = "Şifreler uyuşmuyor");
      return;
    }

    // Şifreyi hashle
    final hashedPassword = hashPassword(newPassword);

    // SAP servis işlemlerini geçici olarak yorum satırına aldık
    print("Yeni Şifre (Hashlenmiş): $hashedPassword");

    // Buradaki SAP işlemleri geçici olarak şu şekilde yorumlanmıştır:
    /*
    SAPService().updatePassword(hashedPassword).then((_) {
      print("Şifre başarıyla güncellendi!");
    }).catchError((error) {
      print("Hata: $error");
    });
    */

    // Şifre başarılı şekilde belirlenince login ekranına yönlendir
    print("Şifre başarıyla kaydedildi!");
    Navigator.pushReplacementNamed(context, '/');
  }
}
