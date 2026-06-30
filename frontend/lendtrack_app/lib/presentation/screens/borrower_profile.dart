import 'package:flutter/material.dart';

class BorrowerProfileScreen extends StatelessWidget {
  final int borrowerId;
  const BorrowerProfileScreen({super.key, required this.borrowerId});

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
      body: Center(
        child: Text('Borrower Profile - ID: $borrowerId'),
      ),
    );
  }
}
