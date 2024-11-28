import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String apiUrl = "http://localhost:3000/add-user";

  // Kullanıcı ekleme fonksiyonu
  static Future<String> addUser({
    required String name,
    required String surname,
    required String? tckn,
    required String? vkn,
    required String email,
    required String password,
  }) async {
    // Kullanıcı verilerini hazırlayın
    var user = {
      "type": "Vendor", // Statik bir değer
      "name": name,
      "surname": surname,
      "tckn": tckn,
      "vkn": vkn,
      "email": email,
      "password": password,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user),
      );

      if (response.statusCode == 201) {
        return "Kullanıcı başarıyla eklendi!";
      } else {
        return "Kullanıcı eklenemedi: ${response.body}";
      }
    } catch (e) {
      return "Hata oluştu: $e";
    }
  }
}