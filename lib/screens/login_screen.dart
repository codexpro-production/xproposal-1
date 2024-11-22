import 'dart:html' as html;
import 'package:flutter/material.dart';
// import '../services/sap_service.dart'; // SAP servisi şimdilik yorum satırına alındı
import '../services/verify_token.dart';
import '../widgets/captcha_widget.dart'; // reCAPTCHA widget'ını dahil edin
import '../screens/xproposal_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  final _tcVknController = TextEditingController(); // TC Kimlik Numarası veya VKN için kontrol
  bool _obscureText = true;
  String? _captchaToken;
  String _captchaFeedback = '';  // CAPTCHA geri bildirim mesajı
  String _tcVknFeedback = '';  // TC Kimlik veya VKN geri bildirim mesajı

  @override
  void initState() {
    super.initState();

    // reCAPTCHA'dan gelen token'ı dinleyin ve doğrulamayı başlatın
    html.window.onMessage.listen((msg) {
      String token = msg.data; // reCAPTCHA yanıt token'ı
      setState(() {
        _captchaToken = token;
      });
    });
  }

  bool isValidTcOrVkn(String value) {
    // 11 haneli olup olmadığını kontrol et
    if (value.length != 11 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return false;
    }
    return true;
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
                    image: AssetImage('assets/images/login_image.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Sağ kısımda form alanı
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                              controller: _tcVknController,
                              decoration: InputDecoration(
                                labelText: "*TC Kimlik Numarası veya VKN",
                                prefixIcon: Icon(Icons.credit_card),
                              ),
                              maxLength: 11,  // Sadece 11 haneli girişe izin ver
                              keyboardType: TextInputType.number, // Sayısal giriş için
                            ),
                            SizedBox(height: 16),

                            // TC Kimlik No veya VKN geri bildirim mesajı
                            if (_tcVknFeedback.isNotEmpty)
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _tcVknFeedback.contains("geçerli")
                                      ? Colors.green[100]
                                      : Colors.red[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
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

                            CaptchaWidget(
                              onValidate: (isValid) {
                                setState(() {
                                  if (isValid) {
                                    _captchaFeedback = "CAPTCHA doğru!";
                                  } else {
                                    _captchaFeedback = "Lütfen tekrar deneyin.";
                                  }
                                });
                              },
                            ),  // CAPTCHA alanı
                            SizedBox(height: 10),

                            // CAPTCHA geri bildirim mesajı
                            if (_captchaFeedback.isNotEmpty)
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _captchaFeedback.contains("doğru")
                                      ? Colors.green[100]
                                      : Colors.red[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
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

                            SizedBox(height: 20),

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

  Future<void> _login() async {
    final tcVkn = _tcVknController.text;
    final password = _passwordController.text;

    if (tcVkn.isEmpty || !isValidTcOrVkn(tcVkn)) {
      setState(() {
        _tcVknFeedback = "TC Kimlik Numarası-VKN eksik ";
      });
      return;
    }

    try {
      // SAP işlemleri şimdilik devre dışı bırakıldı.
      // final user = await SAPService().authenticateUserByTcVkn(tcVkn, password);
      
      // Geçici olarak başarılı bir giriş sağlanmış gibi simüle edelim
      final user = true; // Bu kısmı geçici olarak simüle ediyoruz.
      
      if (user != null && user) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kullanıcı adı veya şifre hatalı.")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş hatası: $error")),
      );
    }
  }
} 