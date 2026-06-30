import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/core/navigation/navigation_helper.dart';
import 'package:lendtrack_app/data/providers/borrower_provider.dart';
import 'package:lendtrack_app/data/providers/loan_provider.dart';
import 'package:lendtrack_app/data/models/borrower.dart';
import 'package:lendtrack_app/data/models/loan.dart';

class BorrowerProfileScreen extends ConsumerStatefulWidget {
  final int borrowerId;
  const BorrowerProfileScreen({super.key, required this.borrowerId});

  @override
  ConsumerState<BorrowerProfileScreen> createState() => _BorrowerProfileScreenState();
}

class _BorrowerProfileScreenState extends ConsumerState<BorrowerProfileScreen> {
  Borrower? _borrower;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load borrowers first
      await ref.read(borrowerProvider.notifier).loadBorrowers();
      await ref.read(loanProvider.notifier).loadLoans();
      
      final borrowers = ref.read(borrowerProvider);
      final found = borrowers.firstWhere(
        (b) => b.id == widget.borrowerId,
        orElse: () => borrowers.first,
      );
      
      setState(() {
        _borrower = found;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyBorrower() async {
    if (_borrower == null) return;
    
    setState(() => _isLoading = true);
    
    final success = await ref.read(borrowerProvider.notifier).verifyBorrower(_borrower!.id);
    
    if (success && mounted) {
      // Reload data
      await _loadData();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Borrower verified successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Failed to verify borrower'),
          backgroundColor: Colors.red,
        ),
      );
    }
    
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final loans = ref.watch(loanProvider);
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Borrower Profile'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: NavigationHelper.goBack,
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_borrower == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Borrower Profile'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: NavigationHelper.goBack,
          ),
        ),
        body: const Center(
          child: Text('Borrower not found'),
        ),
      );
    }

    final borrowerLoans = loans.where((l) => l.borrowerId == widget.borrowerId).toList();
    final totalBorrowed = borrowerLoans.fold(0.0, (sum, l) => sum + l.amount);
    final totalRepaid = borrowerLoans
        .where((l) => l.status == 'completed')
        .fold(0.0, (sum, l) => sum + l.amount);
    final outstanding = borrowerLoans
        .where((l) => l.status == 'active' || l.status == 'pending')
        .fold(0.0, (sum, l) => sum + l.outstandingBalance);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrower Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Refresh the list before going back
            ref.read(borrowerProvider.notifier).loadBorrowers();
            NavigationHelper.goBack();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 24),

            // Verification Action (if pending)
            if (_borrower!.status == 'pending' || !_borrower!.isVerified) ...[
              _buildVerificationCard(),
              const SizedBox(height: 24),
            ],

            // Stats Cards
            _buildStatsCards(totalBorrowed, totalRepaid, outstanding),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(),
            const SizedBox(height: 24),

            // Loan History
            _buildLoanHistory(borrowerLoans),
            const SizedBox(height: 24),

            // Borrower Info
            _buildBorrowerInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  _borrower!.fullName.isNotEmpty ? _borrower!.fullName[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: _borrower!.statusColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    _borrower!.isVerified ? Icons.verified : 
                    (_borrower!.status == 'pending' ? Icons.pending : Icons.error),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _borrower!.fullName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _borrower!.phone,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _borrower!.email,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _borrower!.statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _borrower!.statusDisplay,
              style: TextStyle(
                color: _borrower!.statusColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: Colors.orange.shade700, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pending Verification',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'This borrower needs to be verified before they can get loans.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _verifyBorrower,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Verify Now',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(double totalBorrowed, double totalRepaid, double outstanding) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Borrowed',
            value: 'MK ${_formatNumber(totalBorrowed)}',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Total Repaid',
            value: 'MK ${_formatNumber(totalRepaid)}',
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Outstanding',
            value: 'MK ${_formatNumber(outstanding)}',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 24,
              height: 3,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _borrower!.isVerified ? NavigationHelper.goToDisburse : null,
            icon: const Icon(Icons.send, size: 18),
            label: const Text('Disburse'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _borrower!.isVerified ? Colors.blue : Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _borrower!.isVerified ? NavigationHelper.goToRequestRepayment : null,
            icon: const Icon(Icons.payment, size: 18),
            label: const Text('Repayment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _borrower!.isVerified ? Colors.green : Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoanHistory(List<Loan> loans) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Loan History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (loans.isNotEmpty)
              Text(
                '${loans.length} loans',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (loans.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Center(
              child: Text(
                'No loan history yet',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ...loans.map((loan) => _buildLoanHistoryCard(loan)),
      ],
    );
  }

  Widget _buildLoanHistoryCard(Loan loan) {
    final isActive = loan.status == 'active' || loan.status == 'pending';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MK ${loan.amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: loan.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    loan.statusDisplay,
                    style: TextStyle(
                      fontSize: 11,
                      color: loan.statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Due: ${loan.dueDate}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.percent, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${loan.interestRate}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${loan.termMonths}m',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            if (loan.purpose != null) ...[
              const SizedBox(height: 4),
              Text(
                'Purpose: ${loan.purpose}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
            if (loan.status == 'active') ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Outstanding: MK ${loan.outstandingBalance.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment page coming soon')),
                      );
                    },
                    child: const Text('Pay Now'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: 1 - (loan.outstandingBalance / loan.amount),
                backgroundColor: Colors.grey.shade200,
                color: Colors.green,
                minHeight: 6,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${((1 - (loan.outstandingBalance / loan.amount)) * 100).toStringAsFixed(0)}% repaid',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Text(
                    'MK ${(loan.amount - loan.outstandingBalance).toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBorrowerInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Borrower Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Address', _borrower!.address),
            _buildInfoRow('National ID', _borrower!.nationalId ?? 'Not provided'),
            _buildInfoRow('Verification Status', _borrower!.statusDisplay),
            _buildInfoRow('Account Status', _borrower!.isActive ? 'Active' : 'Inactive'),
            if (_borrower!.createdAt != null)
              _buildInfoRow('Joined', _borrower!.createdAt!.split('T').first),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
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
