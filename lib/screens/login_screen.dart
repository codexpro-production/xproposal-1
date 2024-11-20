import 'dart:html' as html;
import 'package:flutter/material.dart';
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
  String? _captchaToken; // Token'ı saklamak için bir değişken

  @override
  void initState() {
    super.initState();

    // reCAPTCHA'dan gelen token'ı dinleyin
    html.window.onMessage.listen((msg) {
  String token = msg.data; // reCAPTCHA yanıt token'ı
  verifyToken(token).then((isVerified) {
    if (isVerified) {
      // Eğer doğrulama başarılıysa, başka bir sayfaya geçebilirsiniz
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => XProposalPage()),
      );
    } else {
      // Doğrulama başarısızsa bir hata mesajı gösterebilirsiniz
      print('reCAPTCHA doğrulama başarısız.');
    }
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
                    image: AssetImage('../assests/images/login_image.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Sağ kısımda form alanı
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(16),
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

                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                          children: [
                            TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: "*Kullanıcı Adı",
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(height: 16),

                            TextField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: "*Şifre",
                                prefixIcon: Icon(Icons.lock),
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
                      SizedBox(height: 20),

                      Text(
                        "* İşaretli alanların doldurulması zorunludur.",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),

                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/helpDocument');
                        },
                        child: Text("Yardım Dokümanı"),
                      ),
                    ],
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("CAPTCHA doğrulaması eksik!")));
      return;
    }

    // CAPTCHA doğrulamasını yap
    final isCaptchaValid = await verifyToken(_captchaToken!);
    if (!isCaptchaValid) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("CAPTCHA doğrulaması başarısız.")));
      return;
    }

    // Kullanıcı doğrulama işlemi
    SAPService().authenticateUser(username, password).then((user) {
      Navigator.pushReplacementNamed(context, '/home');
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Giriş hatası: $error")));
    });
  }
}
