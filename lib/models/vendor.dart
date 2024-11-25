class Vendor {
  final String name1;
  final String lifnr;
  final String? email;

  Vendor({required this.name1, required this.lifnr, this.email});

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      name1: json['name1'] as String,
      lifnr: json['lifnr'] as String,
      email: json['email'] as String?,
    );
  }
}
