import 'dart:math';
import 'package:flutter/material.dart';
import 'captcha_painter.dart';

// CAPTCHA metni üretme fonksiyonu
String generateCaptcha({int length = 5}) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  Random rnd = Random();
  return String.fromCharCodes(
    Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
  );
}

class CaptchaWidget extends StatefulWidget {
  final Function(bool) onValidate; // onValidate parametresi

  const CaptchaWidget({super.key, required this.onValidate}); // Constructor

  @override
  _CaptchaWidgetState createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  String captchaText = generateCaptcha();
  final TextEditingController captchaController = TextEditingController();

  // CAPTCHA'yı yenileme fonksiyonu
  void regenerateCaptcha() {
    setState(() {
      captchaText = generateCaptcha();
    });
  }

  // CAPTCHA doğrulama fonksiyonu
  void validateCaptcha() {
    bool isValid = captchaController.text == captchaText;
    widget.onValidate(isValid);  // Doğrulama sonucunu geri gönder

    if (isValid) {
      setState(() {
        // Doğru CAPTCHA sonucu
      });
    } else {
      setState(() {
        // Yanlış CAPTCHA sonucu
        regenerateCaptcha();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              height: 50,
              child: CustomPaint(
                painter: CaptchaPainter(captchaText),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: captchaController,
                decoration: const InputDecoration(
                  labelText: "CAPTCHA'yı girin",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: validateCaptcha,
              child: const Text("Doğrula"),
            ),
          ],
        ),
        TextButton(
          onPressed: regenerateCaptcha,
          child: const Text("CAPTCHA’yı yenile"),
        ),
      ],
    );
  }
}
