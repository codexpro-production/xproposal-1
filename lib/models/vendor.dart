class Vendor {
  final String name1;
  final String lifnr;
  final String email;

  Vendor({required this.name1, required this.lifnr, required this.email});

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      name1: json['name1'] ?? 'Unknown',
      lifnr: json['lifnr'] ?? '000000',
      email: json['email'] ?? 'Unknown',
    );
  }
}
