import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/data/providers/loan_provider.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends ConsumerState<TransactionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loanProvider.notifier).loadLoans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loans = ref.watch(loanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: loans.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No transactions yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: loans.length,
              itemBuilder: (context, index) {
                final loan = loans[index];
                final isDebit = loan.status == 'active' || loan.status == 'pending';
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isDebit ? Colors.red.shade50 : Colors.green.shade50,
                      child: Icon(
                        isDebit ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isDebit ? Colors.red : Colors.green,
                      ),
                    ),
                    title: Text(loan.borrowerName, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Due: ${loan.dueDate}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                          decoration: BoxDecoration(
                            color: loan.statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            loan.statusDisplay,
                            style: TextStyle(fontSize: 10, color: loan.statusColor, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      isDebit ? '-MK ${loan.amount.toStringAsFixed(0)}' : '+MK ${loan.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDebit ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
