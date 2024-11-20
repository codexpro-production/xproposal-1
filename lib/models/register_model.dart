// models/user.dart
class Register {
  final String vknTckn;
  final String email;
  final bool isBlocked;

  Register({
    required this.vknTckn,
    required this.email,
    required this.isBlocked,
  });

  // JSON verisini User modeline dönüştürme
  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      vknTckn: json['vknTckn'],
      email: json['email'],
      isBlocked: json['isBlocked'],
    );
  }
}
