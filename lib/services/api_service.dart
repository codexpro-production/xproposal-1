import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:5000/documents';

  Future<void> createDocument(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      print('Document created successfully');
    } else {
      print('Failed to create document: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDocuments() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      print('Failed to fetch documents: ${response.body}');
      return [];
    }
  }

  Future<void> updateDocument(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      print('Document updated successfully');
    } else {
      print('Failed to update document: ${response.body}');
    }
  }

  Future<void> deleteDocument(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      print('Document deleted successfully');
    } else {
      print('Failed to delete document: ${response.body}');
    }
  }
}




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
