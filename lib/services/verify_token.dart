import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> verifyToken(String token) async {
  Uri uri = Uri.parse('https://www.google.com/recaptcha/api/siteverify');
  final response = await http.post(
    uri,
    body: {
      'secret': '6LeLnoQqAAAAAJWejQjKAbtBwMURhdftgwmIh-fN', // Gizli anahtarınızı buraya ekleyin
      'response': token,
    },
  );
  final Map<String, dynamic> jsonResponse = json.decode(response.body);
  return jsonResponse['success'] == true;
}
