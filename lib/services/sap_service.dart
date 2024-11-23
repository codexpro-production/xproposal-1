import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vendor.dart';

class SAPService {
  final String _baseUrl = "https://cors-anywhere.herokuapp.com/http://10.1.4.21:50000/zxproposal";

  final String _username = "bkurt";
  final String _password = "Artvin0808";

  // Helper method to get headers
  Map<String, String> _getHeaders() {
    return {
      'Authorization': 'Basic ${base64Encode(utf8.encode("$_username:$_password"))}',
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',  // Add this header
    };
  }


  // Helper method to handle errors
  void _handleError(http.Response response) {
    throw Exception("HTTP Error: ${response.statusCode}, Body: ${response.body}");
  }

  // User authentication
  Future<Map<String, dynamic>> authenticateUser(String username, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/authenticateUser"),
      headers: _getHeaders(),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      _handleError(response);
    }

    throw Exception("Unexpected error during user authentication.");
  }

  // Validate VKN/TCKN and email
  Future<bool> validateVknTcknAndEmail(String vknTckn, String email) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/validateVknTcknAndEmail"),
      headers: _getHeaders(),
      body: jsonEncode({
        'vknTckn': vknTckn,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isValid'] as bool;
    } else {
      _handleError(response);
    }

    throw Exception("Unexpected error during VKN/TCKN and email validation.");
  }

  // Check if blocked
  Future<bool> checkIfBlocked(String vknTckn) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/checkBlockedStatus"),
      headers: _getHeaders(),
      body: jsonEncode({
        'vknTckn': vknTckn,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isBlocked'] as bool;
    } else {
      _handleError(response);
    }

    throw Exception("Unexpected error during block status check.");
  }

  // Send activation link
  Future<void> sendActivationLink(String email) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/sendActivationLink"),
      headers: _getHeaders(),
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/updatePassword"),
      headers: _getHeaders(),
      body: jsonEncode({'newPassword': newPassword}),
    );

    if (response.statusCode != 200) {
      _handleError(response);
    }
  }

  // Register user
  Future<bool> registerUser(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/registerUser"),
      headers: _getHeaders(),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Successfully registered
    } else {
      _handleError(response);
    }

    throw Exception("Unexpected error during user registration.");
  }

  // Fetch vendors
  Future<List<Vendor>> fetchVendors({String? vendorNo}) async {
    final url = vendorNo != null
        ? '$_baseUrl/VENDOR_LIST?VENDOR_NO=$vendorNo'
        : '$_baseUrl/VENDOR_LIST';

    final response = await http.get(
      Uri.parse(url),
      // headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Vendor.fromJson(json)).toList();
    } else {
      _handleError(response);
    }

    throw Exception("Unexpected error occurred while fetching vendors.");
  }
}
