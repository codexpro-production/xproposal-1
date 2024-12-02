import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uni_links/uni_links.dart';

class PasswordSetupScreen extends StatefulWidget {
  String? token;

  PasswordSetupScreen({super.key, required this.token});

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
    _initDeepLinkListener();
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
        Timer(const Duration(seconds: 2), () {
          setState(() => _showNewPassword = false);
        });
      } else {
        _showConfirmPassword = true;
        Timer(const Duration(seconds: 2), () {
          setState(() => _showConfirmPassword = false);
        });
      }
    });
  }

  Future<void> _setPassword() async {
  final newPassword = _newPasswordController.text;
  final confirmPassword = _confirmPasswordController.text;

  if (newPassword.isEmpty || confirmPassword.isEmpty) {
    setState(() => _errorMessage = "Lütfen tüm alanları doldurun.");
    return;
  } 
  else if (newPassword != confirmPassword) {
    setState(() => _errorMessage = "Şifreler uyuşmuyor.");
    return;
  }
  else if (!(_isLengthValid && _hasUppercase && _hasLowercase && _hasDigit && _hasSpecialChar)) {
    setState(() => _errorMessage = "Şifre gereksinimlerini karşılamıyor.");
    return;
  }

  print("Sending request with token: ${widget.token}");
  print("New Password: $newPassword");


  // final token = widget.token;
  // if (token == null || token.isEmpty) {
  //   setState(() => _errorMessage = "Geçersiz token.");
  //   return;
  // }

  try {
    final response = await http.post(
      Uri.parse("http://localhost:3000/api/setup-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": widget.token,
        "password": newPassword,
      }),
    );

    print("Response status code: ${response.statusCode}"); 
    print("Response body: ${response.body}"); 

    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      final error = jsonDecode(response.body)['message'];
      setState(() => _errorMessage = error ?? "Şifre ayarlanırken bir hata oluştu.");
    }
  } catch (e) {
    setState(() => _errorMessage = "Bir hata oluştu: $e");
  }
}

 void _initDeepLinkListener() async {
  final initialUri = await getInitialUri();
  print("Initial URI: $initialUri"); 

  if (initialUri != null) {
    final token = initialUri.queryParameters['token'];
    print("Extracted Token: $token"); 

    if (token != null) {
      setState(() {
        widget.token = token;
      });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Şifre Belirleme")),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
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
              const SizedBox(height: 16),

              // Şifre ve şifre tekrar alanları
              _buildPasswordField("Yeni Şifre", _newPasswordController, _showNewPassword, true),
              _buildPasswordField("Şifre Tekrarı", _confirmPasswordController, _showConfirmPassword, false),
              const SizedBox(height: 16),

              // Şifre Kaydet butonu
              ElevatedButton(
                onPressed: _setPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  foregroundColor: Colors.white,       
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                ),
                child: const Text("Şifreyi Kaydet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementRow(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: isValid ? Colors.green : Colors.red,
            child: Icon(
              isValid ? Icons.check : Icons.close,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

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

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hashed = sha256.convert(bytes);
    return hashed.toString();
  }
}