import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../widgets/captcha_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  final _tcVknController = TextEditingController();
  bool _obscureText = true;
  String? _captchaToken;
  String _captchaFeedback = '';
  String _tcVknFeedback = '';

  @override
  void initState() {
    super.initState();

    html.window.onMessage.listen((msg) {
      String token = msg.data;
      setState(() {
        _captchaToken = token;
      });
    });
  }

  bool isValidTcOrVkn(String value) {
    return value.length == 11 && RegExp(r'^[0-9]+$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Görüntüleme boyutlarını ayarlama
          double imageWidth = constraints.maxWidth > 800
              ? MediaQuery.of(context).size.width * 0.5
              : MediaQuery.of(context).size.width * 0.4;

          return Row(
            children: [
              if (constraints.maxWidth > 800)
                Container(
                  width: imageWidth,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/login_image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
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
                              "HOŞGELDİNİZ",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),

                            TextField(
                              controller: _tcVknController,
                              decoration: const InputDecoration(
                                labelText: "*TC Kimlik Numarası veya VKN",
                                prefixIcon: Icon(Icons.credit_card),
                                border: OutlineInputBorder(),
                              ),
                              maxLength: 11,
                              keyboardType: TextInputType.number,
                            ),
                            if (_tcVknFeedback.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  _tcVknFeedback,
                                  style: TextStyle(
                                    color: _tcVknFeedback.contains("geçerli")
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),

                            TextField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: "*Şifre",
                                prefixIcon: const Icon(Icons.lock),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/passwordReset');
                                },
                                child: const Text(
                                  "Şifremi Unuttum",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                            CaptchaWidget(
                              onValidate: (isValid) {
                                setState(() {
                                  _captchaFeedback = isValid
                                      ? "CAPTCHA doğru!"
                                      : "Lütfen tekrar deneyin.";
                                });
                              },
                            ),
                            if (_captchaFeedback.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  _captchaFeedback,
                                  style: TextStyle(
                                    color: _captchaFeedback.contains("doğru")
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 24),

                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                              ),
                              child: const Text("Giriş Yap"),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: const Text(
                                "Kayıt Ol",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
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

  Future<void> _login() async {
    final tcVkn = _tcVknController.text;
    final password = _passwordController.text;

    if (tcVkn.isEmpty || !isValidTcOrVkn(tcVkn)) {
      setState(() {
        _tcVknFeedback = "TC Kimlik Numarası veya VKN eksik";
      });
      return;
    }

    try {
      const user = true;

      if (user) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kullanıcı adı veya şifre hatalı.")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş hatası: $error")),
      );
    }
  }
}
