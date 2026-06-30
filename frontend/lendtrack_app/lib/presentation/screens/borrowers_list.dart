import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/core/navigation/navigation_helper.dart';
import 'package:lendtrack_app/data/providers/borrower_provider.dart';

class BorrowersListScreen extends ConsumerStatefulWidget {
  const BorrowersListScreen({super.key});

  @override
  ConsumerState<BorrowersListScreen> createState() => _BorrowersListScreenState();
}

class _BorrowersListScreenState extends ConsumerState<BorrowersListScreen> {
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBorrowers();
    });
  }

  Future<void> _loadBorrowers() async {
    setState(() => _isLoading = true);
    await ref.read(borrowerProvider.notifier).loadBorrowers();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final borrowers = ref.watch(borrowerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrowers'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: NavigationHelper.goBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBorrowers,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: NavigationHelper.goToAddBorrower,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search borrowers...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadBorrowers,
              child: borrowers.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No borrowers yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                          SizedBox(height: 8),
                          Text('Tap + to add your first borrower', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: borrowers.length,
                      itemBuilder: (context, index) {
                        final borrower = borrowers[index];
                        
                        if (_searchQuery.isNotEmpty &&
                            !borrower.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) &&
                            !borrower.phone.contains(_searchQuery)) {
                          return const SizedBox.shrink();
                        }
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                borrower.fullName.isNotEmpty ? borrower.fullName[0].toUpperCase() : '?',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            title: Text(
                              borrower.fullName,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  borrower.phone,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: borrower.statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        borrower.statusDisplay,
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: borrower.statusColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: borrower.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        borrower.isActive ? 'Active' : 'Inactive',
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: borrower.isActive ? Colors.green : Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => NavigationHelper.goToBorrowerProfile(borrower.id),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
