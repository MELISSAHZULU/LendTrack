import 'package:flutter/material.dart';

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
  final String? status; // 'pending', 'verified', 'active', 'inactive'

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
    this.status,
  });

  Borrower copyWith({
    int? id,
    String? fullName,
    String? phone,
    String? email,
    String? address,
    String? nationalId,
    bool? isVerified,
    bool? isActive,
    String? createdAt,
    String? status,
  }) {
    return Borrower(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      nationalId: nationalId ?? this.nationalId,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

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
      status: json['status'] ?? (json['is_verified'] == true ? 'verified' : 'pending'),
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
      'status': status ?? (isVerified ? 'verified' : 'pending'),
    };
  }

  String get statusDisplay {
    if (status == 'verified' || isVerified) return 'Verified ✅';
    if (status == 'pending') return 'Pending ⏳';
    if (status == 'inactive') return 'Inactive ❌';
    return isActive ? 'Active' : 'Inactive';
  }

  Color get statusColor {
    if (status == 'verified' || isVerified) return Colors.green;
    if (status == 'pending') return Colors.orange;
    if (status == 'inactive') return Colors.red;
    return isActive ? Colors.green : Colors.red;
  }
}
