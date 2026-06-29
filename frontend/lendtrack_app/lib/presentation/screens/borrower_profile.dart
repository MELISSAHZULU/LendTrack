import 'package:flutter/material.dart';

class BorrowerProfileScreen extends StatelessWidget {
  const BorrowerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrower Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Borrower Profile Screen - Coming Soon'),
      ),
    );
  }
}
