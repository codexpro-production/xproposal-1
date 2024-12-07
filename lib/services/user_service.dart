import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String apiUrl = "http://localhost:3000/api/";

  static Future<String> addUser({
required String userType,
    required String name,
    required String surname,
    String? tckn,
    String? vkn,
    required String email,
    required String password,
    String? purchaseGroup,
    int? telNumber,
    int? faxNumber,
    int? responsible,
  }) async {
    final url = Uri.parse("${apiUrl}add-user");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'type': userType,
        'name': name,
        'surname': surname,
        'tckn': tckn,
        'vkn': vkn,
        'email': email,
        'password': password,
        'purchaseGroup': purchaseGroup,
        'telNumber': telNumber,
        'faxNumber': faxNumber,
        'responsible': responsible,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // Update User
  static Future<String> updateUser({
    required String userType,
    required String userId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      var response = await http.put(
        Uri.parse("${apiUrl}update-user/$userType/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        return "Kullanıcı başarıyla güncellendi!";
      } else {
        return "Kullanıcı güncellenemedi: ${response.body}";
      }
    } catch (e) {
      return "Hata oluştu: $e";
    }
  }

  // Delete User
  static Future<String> deleteUser({
    required String userType,
    required String userId,
  }) async {
    try {
      var response = await http.delete(
        Uri.parse("${apiUrl}delete-user/$userType/$userId"),
      );

      if (response.statusCode == 200) {
        return "Kullanıcı başarıyla silindi!";
      } else {
        return "Kullanıcı silinemedi: ${response.body}";
      }
    } catch (e) {
      return "Hata oluştu: $e";
    }
  }

  ///
  ///
    static Future<String?> getActivationToken({required String email}) async {
    final url = 'http://localhost:3000/api/send-activation-link';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['activationToken'];
      } else {
        print('API çağrısı başarısız: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('E-posta gönderme hatası: $e');
      return null;
    }
  }

   static Future<String> setupPassword({required String token, required String password}) async {
    final url = Uri.parse('http://localhost:3000/setup-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'password': password}),
      );

      if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['message'] ?? 'Şifre başarıyla sıfırlandı';
      } catch (e) {
        return 'Sunucudan beklenmedik bir yanıt alındı.';
      }
    } 
    else {
      try {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['message'] ?? 'Bir hata oluştu';
  } catch (e) {
    return 'Sunucudan beklenmedik bir hata alındı.';
  }
}

    } catch (e) {
      return 'Şifre sıfırlama sırasında hata oluştu: $e';
    }
  }






  static Future<String> login({required String tcVkn, required String password}) async {
  try {
    final response = await http.post(
      Uri.parse("http://localhost:3000/api/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "tcVkn": tcVkn,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // `success` değerini kontrol ediyoruz
      if (data["success"] == true) {
        return "success"; // Başarılı giriş
      } else {
        return data["message"] ?? "Kullanıcı adı veya şifre hatalı."; // API'nin döndürdüğü hata mesajı
      }
    } else {
      final data = jsonDecode(response.body);
      return data["message"] ?? "Bilinmeyen bir hata oluştu.";
    }
  } catch (e) {
    return "Bir hata oluştu: $e";
  }
}



static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail'); // 'userEmail' anahtarı ile saklanan e-posta adresi
  }


}
