import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String apiUrl = "http://localhost:3000/api/";

  // Add User
  static Future<String> addUser({
    required String name,
    required String surname,
    String? tckn,
    String? vkn,
    required String email,
    required String password,
    required String userType,  // "Vendor" or "Responsible"
    String? purchaseGroup,     // Only for Responsible
    int? telNumber,            // Only for Responsible
    int? faxNumber,            // Only for Responsible
    int? responsible,          // Only for Responsible
  }) async {
    var user = {
      "type": userType,  // Include the type field
      "name": name,
      "surname": surname,
      "email": email,
      "password": password,
    };

    if (userType == "Vendor") {
      // Vendor-specific fields
      if (tckn != null) {
        user["tckn"] = tckn.toString(); // Convert to String if not null
      }
      if (vkn != null) {
        user["vkn"] = vkn.toString(); // Convert to String if not null
      }
    } else if (userType == "Responsible") {
      // Responsible-specific fields
      if (purchaseGroup != null) {
        user["purchaseGroup"] = purchaseGroup; // Only add if not null
      }
      if (telNumber != null) {
        user["telNumber"] = telNumber.toString(); // Convert to String if not null
      }
      if (faxNumber != null) {
        user["faxNumber"] = faxNumber.toString(); // Convert to String if not null
      }
      if (responsible != null) {
        user["responsible"] = responsible.toString(); // Convert to String if not null
      }
    } else {
      return "Invalid user type!";
    }

    try {
      var response = await http.post(
        Uri.parse("${apiUrl}add-user"),
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

  // Get Users
  static Future<List<dynamic>> getUsers(String userType) async {
    try {
      var response = await http.get(Uri.parse("${apiUrl}get-users/$userType"));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)["users"];
      } else {
        throw Exception("Kullanıcılar getirilemedi");
      }
    } catch (e) {
      throw Exception("Hata oluştu: $e");
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

}
