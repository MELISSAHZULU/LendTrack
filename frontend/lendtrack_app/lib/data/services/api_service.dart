import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'access_token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ============ AUTH ============
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'access_token', value: data['access']);
      await _storage.write(key: 'refresh_token', value: data['refresh']);
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  // ============ DASHBOARD STATS ============
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reports/dashboard/'),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // Fall through to mock data
    }
    // Mock data if backend not ready
    return {
      'total_disbursed': 3250000,
      'total_repaid': 2440000,
      'outstanding': 1297500,
      'overdue_loans': 3,
      'active_loans': 2,
      'recovery_rate': 75.0,
    };
  }

  // ============ BORROWERS ============
  Future<List<dynamic>> getBorrowers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/borrowers/'),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Loaded ${data.length} borrowers');
        return data;
      } else {
        print('❌ Failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createBorrower(Map<String, dynamic> data) async {
    try {
      print('📝 Creating: ${data['full_name']}');
      final response = await http.post(
        Uri.parse('$baseUrl/borrowers/'),
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      
      if (response.statusCode == 201) {
        final result = jsonDecode(response.body);
        print('✅ Created!');
        return result;
      } else {
        throw Exception('Failed: ${response.body}');
      }
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  // ============ LOANS ============
  Future<List<dynamic>> getLoans() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/loans/'),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // Fall through to mock data
    }
    // Mock data
    return [
      {
        'id': 1,
        'borrower': 1,
        'borrower_name': 'Chisomo Banda',
        'amount': 500000,
        'interest_rate': 10,
        'term_months': 6,
        'outstanding_balance': 230000,
        'status': 'active',
        'purpose': 'Business expansion',
        'due_date': '2024-01-31',
        'created_at': '2024-01-15',
      },
      {
        'id': 2,
        'borrower': 2,
        'borrower_name': 'Thandiwe Phiri',
        'amount': 800000,
        'interest_rate': 12,
        'term_months': 12,
        'outstanding_balance': 460000,
        'status': 'active',
        'purpose': 'Education',
        'due_date': '2024-06-15',
        'created_at': '2024-02-20',
      },
    ];
  }

  Future<Map<String, dynamic>> createLoan(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/loans/'),
        headers: await _getHeaders(),
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // Return mock response
      return {
        ...data,
        'id': DateTime.now().millisecondsSinceEpoch,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      };
    }
    throw Exception('Failed to create loan');
  }

  // ============ TRANSACTIONS ============
  Future<List<dynamic>> getTransactions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/payments/'),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // Fall through to mock data
    }
    return [
      {
        'id': 1,
        'borrower_name': 'Chisomo Banda',
        'amount': 500000,
        'type': 'disbursement',
        'status': 'completed',
        'date': '2024-01-15T09:42:00',
      },
      {
        'id': 2,
        'borrower_name': 'Chisomo Banda',
        'amount': 115000,
        'type': 'repayment',
        'status': 'completed',
        'date': '2024-02-15T14:22:00',
      },
    ];
  }
}
