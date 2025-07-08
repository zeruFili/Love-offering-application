class PaymentRecord {
  final String status;
  final String refId;
  final String type;
  final DateTime createdAt;
  final String currency;
  final double amount;
  final double charge;
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;
  final String paymentMethod;

  PaymentRecord({
    required this.status,
    required this.refId,
    required this.type,
    required this.createdAt,
    required this.currency,
    required this.amount,
    required this.charge,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.paymentMethod,
  });

  // Factory method to create a PaymentRecord from JSON
  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      status: json['status'] ?? '',
      refId: json['ref_id'] ?? '',
      type: json['type'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      currency: json['currency'] ?? '',
      amount: double.tryParse(json['amount']) ?? 0.0,
      charge: double.tryParse(json['charge']) ?? 0.0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
    );
  }

  // Method to convert PaymentRecord to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'ref_id': refId,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'currency': currency,
      'amount': amount.toString(),
      'charge': charge.toString(),
      'first_name': firstName,
      'last_name': lastName,
      'mobile': mobile,
      'email': email,
      'payment_method': paymentMethod,
    };
  }
}
