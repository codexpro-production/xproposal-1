import 'package:flutter/material.dart';
import '../services/mail_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _vknTcknController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isButtonEnabled = false;
  String? _message;
  Color _messageColor = Colors.green;

  Future<void> _sendActivationLink() async {
    final vknTckn = _vknTcknController.text;
    final email = _emailController.text;

    if (!_isValidEmail(email)) {
      _showMessage("Lütfen geçerli bir e-posta adresi girin.", Colors.red);
      return;
    }

    else if (!_isValidTcOrVkn(vknTckn)) {
      _showMessage("Lütfen geçerli bir TC Kimlik No veya VKN girin.", Colors.red);
      return;
    }
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegExp.hasMatch(email);
  }

  bool _isValidTcOrVkn(String value) {
    return value.length >= 10 && RegExp(r'^[0-9]+$').hasMatch(value);
  }

  void _showMessage(String message, Color color) {
    setState(() {
      _message = message;
      _messageColor = color;
    });
  }

  void _checkFields() {
    setState(() {
      _isButtonEnabled = _vknTcknController.text.isNotEmpty && _emailController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/login_image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12,
                              spreadRadius: 4,
                              color: Colors.grey.withOpacity(0.25),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Yeni Kullanıcı Oluştur",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            const Text("Lütfen VKN/TCKN girin"),
                            TextField(
                              controller: _vknTcknController,
                              onChanged: (_) => _checkFields(),
                              keyboardType: TextInputType.number,
                              maxLength: 11,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Vergi Kimlik No veya T.C. Kimlik No",
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text("Lütfen E-Posta Adresinizi Girin"),
                            TextField(
                              controller: _emailController,
                              onChanged: (_) => _checkFields(),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "E-posta",
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _isButtonEnabled ? _sendActivationLink : null,
                              child: const Text("Yeni Kullanıcı Oluştur"),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            // Mesaj alanı
                            if (_message != null) ...[
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _messageColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _message!,
                                  style: TextStyle(
                                    color: _messageColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}