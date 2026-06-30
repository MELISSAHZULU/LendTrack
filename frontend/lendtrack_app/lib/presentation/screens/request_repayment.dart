import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/data/providers/borrower_provider.dart';
import 'package:lendtrack_app/data/providers/loan_provider.dart';

class RequestRepaymentScreen extends ConsumerStatefulWidget {
  const RequestRepaymentScreen({super.key});

  @override
  ConsumerState<RequestRepaymentScreen> createState() => _RequestRepaymentScreenState();
}

class _RequestRepaymentScreenState extends ConsumerState<RequestRepaymentScreen> {
  String? _selectedBorrower;
  String? _selectedLoan;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(borrowerProvider.notifier).loadBorrowers();
      ref.read(loanProvider.notifier).loadLoans();
    });
  }

  void _generateLink() {
    if (_selectedBorrower == null || _selectedLoan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select borrower and loan'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Payment Link Generated'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.link, color: Colors.blue, size: 48),
                const SizedBox(height: 8),
                const Text('Share this link with the borrower:'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'https://pay.changu.com/link/ABC123',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(icon: const Icon(Icons.message, color: Colors.green), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.email, color: Colors.blue), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.copy, color: Colors.grey), onPressed: () {}),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final borrowers = ref.watch(borrowerProvider);
    final loans = ref.watch(loanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Repayment'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(  // ← Wrapped in SingleChildScrollView
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('💰 Request Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Generate a payment link for the borrower', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 24),

            DropdownButtonFormField<String>(
              value: _selectedBorrower,
              decoration: const InputDecoration(
                labelText: 'Select Borrower *',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: borrowers.map((b) {
                return DropdownMenuItem(value: b.fullName, child: Text(b.fullName));
              }).toList(),
              onChanged: (value) => setState(() {
                _selectedBorrower = value;
                _selectedLoan = null;
              }),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedLoan,
              decoration: const InputDecoration(
                labelText: 'Select Loan *',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: loans.where((l) => l.status == 'active').map((l) {
                return DropdownMenuItem(
                  value: l.id.toString(),
                  child: Text('Loan #${l.id} - MK ${l.outstandingBalance.toStringAsFixed(0)}'),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedLoan = value),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generateLink,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Generate Payment Link', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
