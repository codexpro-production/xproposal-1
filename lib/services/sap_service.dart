import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/register_model.dart';

class SAPService {
  final String _baseUrl = "https://10.1.4.21:44300/zcxp_vendor_srv/VENDOR";
  final String _username = "sdemirtag";
  final String _password = "Codex2024*";

  // Kullanıcı doğrulama
  Future<Map<String, dynamic>> authenticateUser(String username, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/authenticateUser"),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Kullanıcı doğrulama başarısız: ${response.statusCode}");
    }
  }

  // TBL_VENDOR doğrulama (VKN/TCKN ve e-posta)
  Future<bool> validateVknTcknAndEmail(String vknTckn, String email) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/validateVknTcknAndEmail"),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'vknTckn': vknTckn,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isValid'] as bool;
    } else {
      throw Exception("Doğrulama başarısız: ${response.statusCode}");
    }
  }

  // Blokaj kontrolü (BLOKAJ_DURUMU)
  Future<bool> checkIfBlocked(String vknTckn) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/checkBlockedStatus"),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'vknTckn': vknTckn,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isBlocked'] as bool;
    } else {
      throw Exception("Blokaj kontrolü başarısız: ${response.statusCode}");
    }
  }

  // Aktivasyon linki gönderme
  Future<void> sendActivationLink(String email) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/sendActivationLink"),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception("Aktivasyon linki gönderilemedi");
    }
  }

  // Şifre güncelleme
  Future<void> updatePassword(String newPassword) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/updatePassword"),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'newPassword': newPassword}),
    );

    if (response.statusCode != 200) {
      throw Exception("Şifre güncellenemedi");
    }
  }

  // Kullanıcı kaydı
  Future<bool> registerUser(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/registerUser"),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_username:$_password'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Başarıyla kaydedildi
    } else {
      throw Exception("Kullanıcı kaydı başarısız: ${response.body}");
    }
  }
}
