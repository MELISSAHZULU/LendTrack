import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/data/providers/loan_provider.dart';
import 'package:lendtrack_app/data/models/loan.dart';

class BorrowerLoanApplicationScreen extends ConsumerStatefulWidget {
  const BorrowerLoanApplicationScreen({super.key});

  @override
  ConsumerState<BorrowerLoanApplicationScreen> createState() => _BorrowerLoanApplicationScreenState();
}

class _BorrowerLoanApplicationScreenState extends ConsumerState<BorrowerLoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  final _termController = TextEditingController();
  String _selectedPurpose = 'Business';
  bool _isLoading = false;

  final List<String> _purposes = [
    'Business',
    'Education',
    'Medical',
    'Home Improvement',
    'Agriculture',
    'Personal',
    'Other',
  ];

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Create loan application
    final loan = Loan(
      id: 0,
      borrowerId: 1, // Will be replaced with actual borrower ID
      borrowerName: 'Current User', // Will be replaced with actual name
      amount: double.parse(_amountController.text),
      interestRate: 10.0, // Default interest rate
      termMonths: int.parse(_termController.text),
      outstandingBalance: double.parse(_amountController.text),
      status: 'pending',
      purpose: _selectedPurpose,
      dueDate: DateTime.now().add(Duration(days: 30 * int.parse(_termController.text))).toString().split(' ')[0],
    );

    try {
      await ref.read(loanProvider.notifier).addLoan(loan);
      
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 60),
                const SizedBox(height: 16),
                const Text(
                  'Application Submitted!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your loan application for MK ${_amountController.text} has been submitted.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You will receive a notification once reviewed.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Loan'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📝 New Loan Application',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill in the details below to apply for a loan',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Loan Amount (MK) *',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v?.isEmpty == true) return 'Enter loan amount';
                  if (double.tryParse(v!) == null) return 'Enter a valid amount';
                  if (double.parse(v) < 10000) return 'Minimum amount is MK 10,000';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Purpose
              DropdownButtonFormField<String>(
                value: _selectedPurpose,
                decoration: const InputDecoration(
                  labelText: 'Purpose *',
                  prefixIcon: Icon(Icons.assignment_outlined),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                items: _purposes.map((p) {
                  return DropdownMenuItem(value: p, child: Text(p));
                }).toList(),
                onChanged: (value) => setState(() => _selectedPurpose = value!),
              ),
              const SizedBox(height: 16),

              // Purpose Description
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Briefly describe why you need this loan',
                  prefixIcon: Icon(Icons.description_outlined),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                maxLines: 3,
                validator: (v) => v?.isEmpty == true ? 'Please describe the purpose' : null,
              ),
              const SizedBox(height: 16),

              // Repayment Term
              TextFormField(
                controller: _termController,
                decoration: const InputDecoration(
                  labelText: 'Repayment Period (Months) *',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v?.isEmpty == true) return 'Enter repayment period';
                  if (int.tryParse(v!) == null) return 'Enter a valid number';
                  if (int.parse(v) < 1) return 'Minimum 1 month';
                  if (int.parse(v) > 24) return 'Maximum 24 months';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Application Summary',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Amount:', style: TextStyle(fontSize: 13)),
                        Text(
                          'MK ${_amountController.text.isEmpty ? '0' : _amountController.text}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Purpose:', style: TextStyle(fontSize: 13)),
                        Text(
                          _selectedPurpose,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Term:', style: TextStyle(fontSize: 13)),
                        Text(
                          '${_termController.text.isEmpty ? '0' : _termController.text} months',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Submit Application',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
