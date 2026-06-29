import 'package:flutter/material.dart';

class DisburseLoanScreen extends StatelessWidget {
  const DisburseLoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: const Center(
        child: Text('Disburse Loan Screen - Coming Soon'),
      ),
    );
  }
}
