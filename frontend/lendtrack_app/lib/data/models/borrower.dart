class Borrower {
  final int id;
  final String fullName;
  final String phone;
  final String email;
  final String address;
  final String? nationalId;
  final bool isVerified;
  final bool isActive;
  final String? createdAt;

  Borrower({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    this.nationalId,
    this.isVerified = false,
    this.isActive = true,
    this.createdAt,
  });

  factory Borrower.fromJson(Map<String, dynamic> json) {
    return Borrower(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      nationalId: json['national_id'],
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'address': address,
      'national_id': nationalId,
      'is_verified': isVerified,
      'is_active': isActive,
    };
  }
}
