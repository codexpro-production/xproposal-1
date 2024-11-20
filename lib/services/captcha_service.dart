/*
import 'package:captcha_flutter/captcha_flutter.dart';

class CaptchaService {
  // CaptchaController'ı final olmadan tanımlayın çünkü her zaman yeniden oluşturulabilir
  CaptchaController _captchaController = CaptchaController();

  // CAPTCHA doğrulaması
  Future<bool> validateCaptcha(String captchaResponse) async {
    try {
      // CAPTCHA doğrulaması
      bool isValid = await _captchaController.isValidCaptcha(captchaResponse);
      return isValid;
    } catch (e) {
      print('CAPTCHA doğrulama hatası: $e');
      return false;
    }
  }

  // CAPTCHA'yı yeniden başlatmak için ek bir fonksiyon
  void refreshCaptcha() {
    _captchaController = CaptchaController();
  }

  Future<void> submitCaptcha() async {
  // CAPTCHA yanıtını al
  String captchaResponse = await _captchaController.getCaptchaResponse();

  // CAPTCHA yanıtını backend'e gönder
  final isValid = await CaptchaService().validateCaptcha(captchaResponse);

  if (isValid) {
    print('CAPTCHA doğrulandı.');
  } else {
    print('CAPTCHA doğrulama başarısız.');
  }
}

}
*/