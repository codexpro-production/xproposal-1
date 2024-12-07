import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../widgets/captcha_widget.dart';
import '../services/user_service.dart';

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
  String _generalError = '';

  @override
  void initState() {
    super.initState();

    html.window.onMessage.listen((msg) {
      String token = msg.data;
      setState(() {
        _captchaToken = token; // Token'ı doğru şekilde alıyoruz
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
                            // Genel hata mesajı burada gösterilecek
                            if (_generalError.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  _generalError,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                  Navigator.pushNamed(context, '/passwordReset', arguments: _tcVknController.text);
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
                                  if (isValid) {
                                    // Doğruysa sadece token güncellenir
                                    _captchaToken = "valid-captcha-token";
                                    _captchaFeedback = ""; // Geri bildirim verilmez
                                  } else {
                                    // Yanlışsa bildirim yapılır ve token sıfırlanır
                                    _captchaToken = null;
                                    _captchaFeedback = "CAPTCHA yanlış, lütfen tekrar deneyin.";
                                  }
                                });
                              },
                              onReset: () {
                                setState(() {
                                  // CAPTCHA sıfırlandığında token sıfırlanır
                                  _captchaToken = null;
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
                              onPressed: isCaptchaValid() ? _login : null,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                              ),
                              child: const Text("Giriş Yap"),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
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

  bool isCaptchaValid() {
    // _captchaToken kontrolü, token'ın doğru şekilde alınıp alınmadığını kontrol ediyoruz
    print("Captcha token: $_captchaToken");
    return _captchaToken != null && _captchaToken!.isNotEmpty;
  }

  Future<void> _login() async {
    final tcVkn = _tcVknController.text;
    final password = _passwordController.text;

    // Reset error messages before new validation
    setState(() {
      _generalError = ''; // Clear previous errors
      _tcVknFeedback = '';
      _captchaFeedback = '';
    });

    // Validate TC/VKN and password
    if (tcVkn.isEmpty || !isValidTcOrVkn(tcVkn)) {
      setState(() {
        _generalError = " Hatalı TC Kimlik Numarası, VKN veya şifre!!";
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        _generalError = "Şifre boş olamaz!";
      });
      return;
    }
    if (!isCaptchaValid()) {
      setState(() {
        _captchaFeedback = "Lütfen CAPTCHA doğrulamasını tamamlayın.";
        _generalError = "CAPTCHA doğrulaması hatalı!";
      });
      return;
    }

    // Proceed with login
    try {
      final message = await UserService.login(tcVkn: tcVkn, password: password);
      print('Login yanıtı: $message'); 

      if (message == "success") {
        Navigator.pushReplacementNamed(context, '/xproposal'); 
      } else {
        setState(() {
          _generalError = "Hatalı TC Kimlik Numarası, VKN veya şifre.";
        });
      }
    } catch (error) {
      print('Hata: $error');
      setState(() {
        _generalError = "Giriş hatası: $error";
      });
    }
  }
}
