import 'dart:math';
import 'package:flutter/material.dart';
import 'captcha_painter.dart';

String generateCaptcha({int length = 5}) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghıjklmnopqrstuvwxyz1234567890';
  Random rnd = Random();
  return String.fromCharCodes(
    Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
  );
}

class CaptchaWidget extends StatefulWidget {
  final Function(bool) onValidate;
  final VoidCallback? onReset;

  const CaptchaWidget({Key? key, required this.onValidate, this.onReset}) : super(key: key);

  @override
  _CaptchaWidgetState createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  String captchaText = generateCaptcha();
  final TextEditingController captchaController = TextEditingController();
  bool isCaptchaValid = false;

  void regenerateCaptcha() {
    setState(() {
      captchaText = generateCaptcha();
      isCaptchaValid = false; 
      captchaController.clear();
    });

    if (widget.onReset != null) {
      widget.onReset!();
    }
  }


  void validateCaptcha() {
    setState(() {
      isCaptchaValid = captchaController.text == captchaText;
    });

    widget.onValidate(isCaptchaValid);
    if (!isCaptchaValid) {
      regenerateCaptcha(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                decoration: InputDecoration(
                  labelText: "CAPTCHA'yı girin",
                  border: const OutlineInputBorder(),
                  errorText: isCaptchaValid ? null : "CAPTCHA geçersiz",
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: regenerateCaptcha,
              child: const Text("CAPTCHA’yı yenile"),
            ),
            ElevatedButton(
              onPressed: validateCaptcha,
              child: const Text("Doğrula"),
            ),
          ],
        ),
      ],
    );
  }
}
