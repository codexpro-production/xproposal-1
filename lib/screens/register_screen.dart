import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/mail_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
   final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController tcknVknController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _isButtonEnabled = false;
  String? _message;
  Color _messageColor = Colors.green;


    Future<void> handleAddUser() async {
    // TCKN veya VKN kontrolü
    String? tckn;
    String? vkn;
    final tcknVknValue = tcknVknController.text.trim();

    if (tcknVknValue.length == 11) {
      tckn = tcknVknValue;
      vkn = null;
    } else if (tcknVknValue.length == 10) {
      vkn = tcknVknValue;
      tckn = null;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen geçerli bir TCKN veya VKN girin!")),
      );
      return;
    }

    // `UserService` sınıfını kullanarak API çağrısını yapın
    String result = await UserService.addUser(
      name: nameController.text.trim(),
      surname: surnameController.text.trim(),
      tckn: tckn,
      vkn: vkn,
      email: emailController.text.trim(),
      password: '',
    );

    // Kullanıcıya sonucu göster
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

    // Başarılıysa alanları temizle
    if (result == "Kullanıcı başarıyla eklendi!") {
      _clearFields();
    }
  }

  void _clearFields() {
    nameController.clear();
    surnameController.clear();
    tcknVknController.clear();
    emailController.clear();
  }


  Future<void> _sendActivationLink() async {
    final vknTckn = tcknVknController.text;
    final email = emailController.text;

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
      _isButtonEnabled = tcknVknController.text.isNotEmpty && emailController.text.isNotEmpty;
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
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: "İsim",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              controller: surnameController,
                              decoration: const InputDecoration(
                                labelText: "Soyisim",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              controller: tcknVknController,
                              onChanged: (_) => _checkFields(),
                              keyboardType: TextInputType.number,
                              maxLength: 11,
                              decoration: const InputDecoration(
                                labelText: "T.C. Kimlik No veya Vergi Kimlik No",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: emailController,
                              onChanged: (_) => _checkFields(),
                              decoration: const InputDecoration(
                                labelText: "E-Posta",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 24),
                           ElevatedButton(
                            onPressed: () async {
                              if (nameController.text.isEmpty ||
                                  surnameController.text.isEmpty ||
                                  tcknVknController.text.isEmpty ||
                                  emailController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Lütfen tüm alanları doldurun!")),
                                );
                                return;
                              }
                              if (_isButtonEnabled) {
                                await handleAddUser();
                                // await sendEmail(email: emailController.text);
                              } else {
                                await _sendActivationLink();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              backgroundColor: _isButtonEnabled ? Colors.blue : Colors.green, // Renk duruma göre değişir
                            ),
                            child: Text(_isButtonEnabled ? "Kullanıcı Ekle" : "Kayıt Ol"),
                          ),
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