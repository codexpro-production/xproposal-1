import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class PasswordResetScreen extends StatefulWidget {
  final String email; // Maskelenmiş e-posta adresi
  PasswordResetScreen({required this.email});

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _emailController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = ""; // Input boş olacak şekilde başlatıyoruz
    _emailController.addListener(_checkFields); // E-posta adresi kontrolü
  }

  // E-posta doğrulama ve butonun aktif olup olmadığını kontrol etme
  void _checkFields() {
    setState(() {
      _isButtonEnabled = _emailController.text == widget.email;
    });
  }

  // Şifre sıfırlama bağlantısını e-posta ile gönderme
  Future<void> _sendResetLink() async {
   
  }

  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // // E-posta adresinin maskelenmesi
  // String _maskEmail(String email) {
  //   final emailParts = email.split('@');
  //   if (emailParts[0].length <= 3) {
  //     return '${emailParts[0]}@${emailParts[1]}';
  //   }
  //   final masked = emailParts[0].substring(0, 3) + '*****@' + emailParts[1];
  //   return masked;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Şifre Sıfırlama'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Şifre sıfırlama işlemi için aşağıdaki E-Posta adresinizi doğrulayın',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Girilen E-Posta: ',
                // ${_maskEmail(widget.email)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-Posta Adresinizi Girin',
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _sendResetLink : null,
                child: Text('Şifre Sıfırlama Linkini Gönder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
