import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionService {
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var hashed = sha256.convert(bytes);
    return hashed.toString();
  }
}
