import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/data/providers/borrower_provider.dart';

class DisburseLoanScreen extends ConsumerStatefulWidget {
  const DisburseLoanScreen({super.key});

  @override
  ConsumerState<DisburseLoanScreen> createState() => _DisburseLoanScreenState();
}

class _DisburseLoanScreenState extends ConsumerState<DisburseLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  String? _selectedBorrower;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(borrowerProvider.notifier).loadBorrowers();
    });
  }

  Future<void> _disburse() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBorrower == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a borrower'), backgroundColor: Colors.orange),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a due date'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
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
              const Text('Loan Disbursed Successfully!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('MK ${_amountController.text} sent to $_selectedBorrower', 
                   style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
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
  }

  @override
  Widget build(BuildContext context) {
    final borrowers = ref.watch(borrowerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disburse Loan'),
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
              const Text('💰 Send Money to Borrower', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Disburse loan funds via PayChangu', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 24),

              // Select Borrower
              DropdownButtonFormField<String>(
                value: _selectedBorrower,
                decoration: const InputDecoration(
                  labelText: 'Select Borrower *',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                items: borrowers.map((borrower) {
                  return DropdownMenuItem(
                    value: borrower.fullName,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(borrower.fullName),
                        Text(borrower.phone, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedBorrower = value),
                validator: (v) => v == null ? 'Select a borrower' : null,
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Loan Amount *',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v?.isEmpty == true) return 'Enter amount';
                  if (double.tryParse(v!) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Due Date
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date *',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null ? 'Select due date' : 
                        '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(color: _selectedDate == null ? Colors.grey : Colors.black),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Purpose
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Purpose (optional)',
                  prefixIcon: Icon(Icons.description_outlined),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _disburse,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Send Money', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
