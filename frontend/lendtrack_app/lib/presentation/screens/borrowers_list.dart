import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/data/providers/borrower_provider.dart';
import 'package:lendtrack_app/presentation/screens/add_borrower.dart';
import 'package:lendtrack_app/presentation/screens/borrower_profile.dart';

class BorrowersListScreen extends ConsumerStatefulWidget {
  const BorrowersListScreen({super.key});

  @override
  ConsumerState<BorrowersListScreen> createState() => _BorrowersListScreenState();
}

class _BorrowersListScreenState extends ConsumerState<BorrowersListScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Active', 'Overdue', 'Completed'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(borrowerProvider.notifier).loadBorrowers();
    });
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
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBorrowerScreen()),
              );
            },
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
      body: borrowers.isEmpty
          ? const Center(
              child: Text('No borrowers found. Add your first borrower!'),
            )
          : Column(
              children: [
                // Filter chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
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
                      },
                    ),
                  ),
                ),
                const Divider(height: 1),

                // Borrower list
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => ref.read(borrowerProvider.notifier).loadBorrowers(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: borrowers.length,
                      itemBuilder: (context, index) {
                        final borrower = borrowers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                borrower.fullName[0],
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
                                Text(
                                  'Verified: ${borrower.isVerified ? "Yes" : "No"}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: borrower.isVerified ? Colors.green : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: borrower.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    borrower.isActive ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: borrower.isActive ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BorrowerProfileScreen(borrowerId: borrower.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
