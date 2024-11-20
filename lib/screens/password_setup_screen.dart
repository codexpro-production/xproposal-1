import 'package:flutter/material.dart';
import '../services/sap_service.dart';

class PasswordSetupScreen extends StatefulWidget {
  @override
  _PasswordSetupScreenState createState() => _PasswordSetupScreenState();
}

class _PasswordSetupScreenState extends State<PasswordSetupScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yeni Şifre Belirle")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: "Yeni Şifre"),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: "Şifre Tekrarı"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _setupPassword,
              child: Text("Şifreyi Değiştir"),
            ),
          ],
        ),
      ),
    );
  }

  void _setupPassword() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword == confirmPassword) {
      SAPService().updatePassword(newPassword).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Şifre başarıyla değiştirildi")));
        Navigator.pushReplacementNamed(context, '/login');
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $error")));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Şifreler uyuşmuyor")));
    }
  }
}
