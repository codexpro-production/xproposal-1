class Vendor {
  final String lifnr;
  final String name1;

  Vendor({required this.lifnr, required this.name1});

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      lifnr: json['lifnr'],
      name1: json['name1'],
    );
  }
}
