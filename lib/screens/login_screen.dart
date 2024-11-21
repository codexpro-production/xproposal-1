import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/sap_service.dart';
import '../services/verify_token.dart';
import '../widgets/recaptcha_widget.dart'; // reCAPTCHA widget'ını dahil edin
import '../screens/xproposal_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  String? _captchaToken;
  String? _errorMessage;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double imageWidth = constraints.maxWidth > 600
              ? MediaQuery.of(context).size.width * 0.4
              : MediaQuery.of(context).size.width * 0.5;

          return Row(
            children: [
              // Sol kısımda fotoğraf alanı
              Container(
                width: imageWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('../assets/images/login_image.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Sağ kısımda form alanı
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 60, horizontal: 16), // Üst ve alt boşluk
                  child: Center(
                    child: Container(
                      width: 400,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 2,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Hoşgeldiniz",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          // Kullanıcı adı
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: "*Kullanıcı Adı (VKN veya TC Kimlik No)",
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(11),
                            ],
                          ),
                          SizedBox(height: 16),

                          // Şifre alanı
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: "*Şifre",
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });

                                  if (!_obscureText) {
                                    // Şifreyi göster, 2 saniye sonra tekrar gizle
                                    Future.delayed(Duration(seconds: 2), () {
                                      setState(() {
                                        _obscureText = true;
                                      });
                                    });
                                  }
                                },
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/passwordReset');
                              },
                              child: Text("Şifremi Unuttum",
                                  style: TextStyle(color: Colors.blue)),
                            ),
                          ),

                          // CAPTCHA alanı
                          RecaptchaWidget(),
                          SizedBox(height: 16),

                          // Hata mesajı
                          if (_errorMessage != null)
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: _login,
                            child: Text("Giriş Yap"),
                          ),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text("Kayıt Ol",
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
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

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (_captchaToken == null) {
      setState(() {
        _errorMessage = "CAPTCHA doğrulaması eksik!";
      });
      return;
    }

    // CAPTCHA doğrulamasını yap
    final isCaptchaValid = await verifyToken(_captchaToken!);
    if (!isCaptchaValid) {
      setState(() {
        _errorMessage = "CAPTCHA doğrulaması başarısız.";
      });
      return;
    }

    // Kullanıcı doğrulama işlemi
    SAPService().authenticateUser(username, password).then((user) {
      Navigator.pushReplacementNamed(context, '/home');
    }).catchError((error) {
      setState(() {
        _errorMessage = "Giriş hatası: $error";
      });
    });
  }
}
