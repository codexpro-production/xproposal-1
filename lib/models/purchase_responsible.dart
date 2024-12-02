class PurchaseResponsible {
  final String purchaseGroup;
  final String purchaseGroupText;
  final String telNumber;
  final String faxNumber;
  final String email;
  final int responsible;

  PurchaseResponsible({
    required this.purchaseGroup,
    required this.purchaseGroupText,
    required this.telNumber,
    required this.faxNumber,
    required this.email,
    required this.responsible,
  });

  factory PurchaseResponsible.fromJson(Map<String, dynamic> json) {
    return PurchaseResponsible(
      purchaseGroup: json['purchaseGroup'],
      purchaseGroupText: json['purchaseGroupText'],
      telNumber: json['telNumber'],
      faxNumber: json['faxNumber'],
      email: json['email'],
      responsible: json['responsible'],
    );
  }
}
