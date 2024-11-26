// // services/api_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   final String baseUrl = 'http://your-backend-api-url.com'; // Backend API URL

//   // Şifre sıfırlama linkini gönderme fonksiyonu
//   Future<bool> sendPasswordResetLink(String email) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/reset-password'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email}),
//     );

//     if (response.statusCode == 200) {
//       return true;  // Başarılı
//     } else {
//       return false;  // Hata
//     }
//   }
// }
