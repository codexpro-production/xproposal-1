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
        Uri.parse(apiUrl + "add-user"),
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
      var response = await http.get(Uri.parse(apiUrl + "get-users/$userType"));

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
        Uri.parse(apiUrl + "update-user/$userType/$userId"),
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
        Uri.parse(apiUrl + "delete-user/$userType/$userId"),
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
}
