import 'package:flutter/material.dart';

class LoanApplicationsScreen extends StatelessWidget {
  const LoanApplicationsScreen({super.key});

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Applications'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Loan Applications - Coming Soon'),
      ),
    );
  }
}
