import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/core/navigation/navigation_helper.dart';
import 'package:lendtrack_app/data/providers/loan_provider.dart';
import 'package:lendtrack_app/data/models/loan.dart';

class LoanApplicationsScreen extends ConsumerStatefulWidget {
  const LoanApplicationsScreen({super.key});

  @override
  ConsumerState<LoanApplicationsScreen> createState() => _LoanApplicationsScreenState();
}

class _LoanApplicationsScreenState extends ConsumerState<LoanApplicationsScreen> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loanProvider.notifier).loadLoans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allLoans = ref.watch(loanProvider);
    
    final loans = _selectedFilter == 'All' 
        ? allLoans 
        : allLoans.where((l) => l.status == _selectedFilter.toLowerCase()).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Applications'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: NavigationHelper.goBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(loanProvider.notifier).loadLoans(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: NavigationHelper.goToApplyLoan,
            tooltip: 'New Application',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Pending', 'Approved', 'Active', 'Completed', 'Rejected'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) => setState(() => _selectedFilter = filter),
                      backgroundColor: Colors.grey.shade100,
                      selectedColor: Colors.blue,
                      checkmarkColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(loanProvider.notifier).loadLoans(),
              child: loans.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No loan applications', style: TextStyle(fontSize: 18, color: Colors.grey)),
                          SizedBox(height: 8),
                          Text('Tap + to create a new application', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: loans.length,
                      itemBuilder: (context, index) {
                        final loan = loans[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        loan.borrowerName,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.ellipsis,
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
                                    const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                                    Text(
                                      'MK ${loan.amount.toStringAsFixed(0)}',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                    Text(
                                      'Due: ${loan.dueDate}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.timer, size: 14, color: Colors.grey),
                                    Text(
                                      '${loan.termMonths} months',
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Purpose: ${loan.purpose ?? 'Not specified'}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Interest: ${loan.interestRate}% | Monthly: MK ${(loan.amount / loan.termMonths).toStringAsFixed(0)}',
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                ),
                                if (loan.status == 'pending') ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            ref.read(loanProvider.notifier).updateLoanStatus(loan.id, 'approved');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('✅ Loan approved! Ready for disbursement.'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Approve', style: TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            ref.read(loanProvider.notifier).updateLoanStatus(loan.id, 'rejected');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('❌ Loan rejected'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Colors.red),
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Reject', style: TextStyle(color: Colors.red)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (loan.status == 'approved') ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.info_outline, color: Colors.blue),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                          child: Text(
                                            'Approved! Go to Disburse to send money.',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: NavigationHelper.goToDisburse,
                                          child: const Text('Disburse Now'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: NavigationHelper.goToApplyLoan,
        icon: const Icon(Icons.add),
        label: const Text('New Application'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
