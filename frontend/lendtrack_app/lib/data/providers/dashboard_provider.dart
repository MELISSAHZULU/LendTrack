import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/data/services/api_service.dart';

class DashboardStats {
  final double totalDisbursed;
  final double totalRepaid;
  final double outstanding;
  final int overdueLoans;
  final int activeLoans;
  final double recoveryRate;

  DashboardStats({
    required this.totalDisbursed,
    required this.totalRepaid,
    required this.outstanding,
    required this.overdueLoans,
    required this.activeLoans,
    required this.recoveryRate,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalDisbursed: (json['total_disbursed'] ?? 0).toDouble(),
      totalRepaid: (json['total_repaid'] ?? 0).toDouble(),
      outstanding: (json['outstanding'] ?? 0).toDouble(),
      overdueLoans: json['overdue_loans'] ?? 0,
      activeLoans: json['active_loans'] ?? 0,
      recoveryRate: (json['recovery_rate'] ?? 0).toDouble(),
    );
  }

  factory DashboardStats.mock() {
    return DashboardStats(
      totalDisbursed: 3250000,
      totalRepaid: 2440000,
      outstanding: 1297500,
      overdueLoans: 3,
      activeLoans: 2,
      recoveryRate: 75.0,
    );
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardStats>((ref) {
  return DashboardNotifier();
});

class DashboardNotifier extends StateNotifier<DashboardStats> {
  DashboardNotifier() : super(DashboardStats.mock());

  final ApiService _api = ApiService();

  Future<void> loadStats() async {
    try {
      final data = await _api.getDashboardStats();
      state = DashboardStats.fromJson(data);
    } catch (e) {
      // Use mock data if backend not available
      state = DashboardStats.mock();
    }
  }
}
