import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/data/providers/dashboard_provider.dart';
import 'package:lendtrack_app/data/providers/borrower_provider.dart';
import 'package:lendtrack_app/presentation/screens/auth/login_screen.dart';
import 'package:lendtrack_app/presentation/screens/borrowers_list.dart';
import 'package:lendtrack_app/presentation/screens/add_borrower.dart';
import 'package:lendtrack_app/presentation/screens/loan_applications.dart';
import 'package:lendtrack_app/presentation/screens/disburse_loan.dart';
import 'package:lendtrack_app/presentation/screens/request_repayment.dart';
import 'package:lendtrack_app/presentation/screens/transaction_history.dart';
import 'package:lendtrack_app/presentation/screens/settings.dart';
import 'package:lendtrack_app/presentation/screens/notifications.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).loadStats();
      ref.read(borrowerProvider.notifier).loadBorrowers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(dashboardProvider);
    final borrowers = ref.watch(borrowerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(dashboardProvider.notifier).loadStats();
          await ref.read(borrowerProvider.notifier).loadBorrowers();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to LendTrack!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${stats.activeLoans} active loans, ${stats.overdueLoans} overdue',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Disbursed',
                      'MK ${_formatNumber(stats.totalDisbursed)}',
                      '+12%',
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Total Repaid',
                      'MK ${_formatNumber(stats.totalRepaid)}',
                      '${stats.recoveryRate}%',
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Outstanding',
                      'MK ${_formatNumber(stats.outstanding)}',
                      '${stats.activeLoans} active',
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Overdue Loans',
                      '${stats.overdueLoans}',
                      'Requires attention',
                      Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildQuickAction(
                    Icons.person_add,
                    'Add Borrower',
                    Colors.blue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddBorrowerScreen()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    Icons.people,
                    'Borrowers',
                    Colors.purple,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BorrowersListScreen()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    Icons.assignment,
                    'Applications',
                    Colors.orange,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoanApplicationsScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildQuickAction(
                    Icons.send,
                    'Disburse',
                    Colors.green,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DisburseLoanScreen()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    Icons.payment,
                    'Repayment',
                    Colors.cyan,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequestRepaymentScreen()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    Icons.history,
                    'History',
                    Colors.indigo,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TransactionHistoryScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Borrowers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Borrowers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BorrowersListScreen()),
                      );
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (borrowers.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No borrowers yet. Add your first borrower!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...List.generate(
                  borrowers.length > 3 ? 3 : borrowers.length,
                  (index) => _buildBorrowerItem(borrowers[index]),
                ),

              const SizedBox(height: 24),

              // Bottom Navigation
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      Icons.dashboard,
                      'Home',
                      true,
                      () {},
                    ),
                    _buildNavItem(
                      Icons.people,
                      'Borrowers',
                      false,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BorrowersListScreen()),
                      ),
                    ),
                    _buildNavItem(
                      Icons.assignment,
                      'Loans',
                      false,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoanApplicationsScreen()),
                      ),
                    ),
                    _buildNavItem(
                      Icons.settings,
                      'Settings',
                      false,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String change, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(change, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBorrowerItem(dynamic borrower) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            borrower.fullName[0],
            style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        title: Text(borrower.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        subtitle: Text(borrower.phone, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: borrower.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            borrower.isActive ? 'Active' : 'Inactive',
            style: TextStyle(fontSize: 9, color: borrower.isActive ? Colors.green : Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.blue : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}
