import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';

class CaptchaPainter extends CustomPainter {
  final String captchaText;

  CaptchaPainter(this.captchaText);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1.5;

    // Arka planın daha pürüzlü görünmesi için
    paint.color = Colors.grey.shade200.withOpacity(0.5);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // CAPTCHA metnini çizme
    final textPainter = TextPainter(
      text: TextSpan(
        text: captchaText,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.85),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height / 2 - textPainter.height / 2,
      ),
    );

    // Yazıyı karıştırmak için daha fazla çizgi ve şekil ekleyelim
    final random = Random();
    for (int i = 0; i < 12; i++) { // Çizgi sayısını artırdık
      paint.color = Colors.blueAccent.shade700.withOpacity(0.5 + random.nextDouble() * 0.5);
      paint.strokeWidth = random.nextDouble() * 2 + 1; // Çizgilerin kalınlığı 1 ila 3 arasında değişir

      final start = Offset(random.nextDouble() * size.width, random.nextDouble() * size.height);
      final end = Offset(random.nextDouble() * size.width, random.nextDouble() * size.height);

      canvas.drawLine(start, end, paint);
    }

    // Noktalar ve kısa çizgiler ekleme
    for (int i = 0; i < 50; i++) {
      paint.color = Colors.black.withOpacity(0.2 + random.nextDouble() * 0.3);
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      if (i % 2 == 0) {
        // Nokta ekleme
        canvas.drawCircle(Offset(x, y), random.nextDouble() * 2, paint);
      } else {
        // Kısa çizgi ekleme
        final offsetEnd = Offset(x + random.nextDouble() * 10 - 5, y + random.nextDouble() * 10 - 5);
        canvas.drawLine(Offset(x, y), offsetEnd, paint..strokeWidth = 1);
      }
    }

    // Yazıyı bulanıklaştırma efekti ekleme
    final filter = ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0); // Bulanıklaştırma
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..imageFilter = filter);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CaptchaPainter oldDelegate) => captchaText != oldDelegate.captchaText;
}
