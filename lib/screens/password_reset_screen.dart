import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool _isButtonEnabled = false;

Future<void> sendEmail({required String email}) async {
  final serviceId = 'service_4xb957a';
  final templateId = 'template_denoaiu';
  final userId = 'VBEKKB7TmBjSpPKIj';  

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  try {
    final response = await http.post(
      url,
      headers: {
        'origin': '*',  
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params':{
          'user_email': email,
        },
      }),
    );
    if (response.statusCode == 200) {
      // Email sent successfully
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Başarılı'),
            content: const Text('Şifre sıfırlama linki gönderildi. Lütfen mail adresinizi kontrol edin.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();  // Close the dialog
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    } else {
      // Failed to send email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send email: ${response.body}')),
      );
    }
  } catch (error) {
    // Error occurred
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $error')),
    );
  }
}

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFields);
  }

  void _checkFields() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifre Sıfırlama'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Şifre sıfırlama işlemi için aşağıdaki E-Posta adresinizi doğrulayın',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sistemdeki E-Posta Adresiniz: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-Posta Adresinizi Girin',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () {
                          if (formKey.currentState!.validate()) {
                            sendEmail(email: _emailController.text);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blue[700],
                  ),
                  child: const Text(
                    'Şifre Sıfırlama Linkini Gönder',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
