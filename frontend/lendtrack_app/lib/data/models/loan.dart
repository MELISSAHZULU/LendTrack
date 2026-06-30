import 'package:flutter/material.dart';

class Loan {
  final int id;
  final int borrowerId;
  final String borrowerName;
  final double amount;
  final double interestRate;
  final int termMonths;
  final double outstandingBalance;
  final String status;
  final String? purpose;
  final String dueDate;
  final String? createdAt;

  Loan({
    required this.id,
    required this.borrowerId,
    required this.borrowerName,
    required this.amount,
    required this.interestRate,
    required this.termMonths,
    required this.outstandingBalance,
    required this.status,
    this.purpose,
    required this.dueDate,
    this.createdAt,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'] ?? 0,
      borrowerId: json['borrower'] ?? 0,
      borrowerName: json['borrower_name'] ?? 'Unknown',
      amount: (json['amount'] ?? 0).toDouble(),
      interestRate: (json['interest_rate'] ?? 0).toDouble(),
      termMonths: json['term_months'] ?? 6,
      outstandingBalance: (json['outstanding_balance'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      purpose: json['purpose'],
      dueDate: json['due_date'] ?? '',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'borrower': borrowerId,
      'amount': amount,
      'interest_rate': interestRate,
      'term_months': termMonths,
      'outstanding_balance': outstandingBalance,
      'status': status,
      'purpose': purpose,
      'due_date': dueDate,
    };
  }

  String get statusDisplay {
    switch (status) {
      case 'pending': return 'Pending';
      case 'approved': return 'Approved';
      case 'active': return 'Active';
      case 'completed': return 'Completed';
      case 'defaulted': return 'Defaulted';
      case 'rejected': return 'Rejected';
      default: return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'approved': return Colors.blue;
      case 'active': return Colors.green;
      case 'completed': return Colors.green;
      case 'defaulted': return Colors.red;
      case 'rejected': return Colors.red;
      default: return Colors.grey;
    }
  }
}
