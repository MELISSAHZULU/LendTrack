import 'package:flutter/material.dart';

class RequestRepaymentScreen extends StatelessWidget {
  const RequestRepaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: const Center(
        child: Text('Request Repayment - Coming Soon'),
      ),
    );
  }
}
