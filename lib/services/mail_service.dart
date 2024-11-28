import 'dart:convert';
import 'package:http/http.dart' as http;

// Function to send email using EmailJS API
Future<void> sendEmail({required String email}) async {
  final serviceId = 'service_4xb957a';
  final templateId = 'template_denoaiu';
  final userId = 'VBEKKB7TmBjSpPKIj';

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  
  try {
    final response = await http.post(
      url,
      headers: {
        'origin': '*',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_email': email,
        },
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to send email: ${response.body}');
    }
  } catch (error) {
    throw Exception('An error occurred: $error');
  }
}
