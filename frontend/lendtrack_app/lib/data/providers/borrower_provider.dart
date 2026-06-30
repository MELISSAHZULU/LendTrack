import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/data/models/borrower.dart';
import 'package:lendtrack_app/data/services/api_service.dart';

final borrowerProvider = StateNotifierProvider<BorrowerNotifier, List<Borrower>>((ref) {
  return BorrowerNotifier();
});

class BorrowerNotifier extends StateNotifier<List<Borrower>> {
  BorrowerNotifier() : super([]);

  final ApiService _api = ApiService();

  Future<void> loadBorrowers() async {
    try {
      final data = await _api.getBorrowers();
      state = data.map((json) => Borrower.fromJson(json)).toList();
    } catch (e) {
      // If backend not available, use mock data
      state = [
        Borrower(
          id: 1,
          fullName: 'Chisomo Banda',
          phone: '+265 999 000 000',
          email: 'chisomo@email.com',
          address: 'Area 12, Lilongwe',
          isVerified: true,
        ),
        Borrower(
          id: 2,
          fullName: 'Thandiwe Phiri',
          phone: '+265 888 000 000',
          email: 'thandiwe@email.com',
          address: 'Area 25, Lilongwe',
          isVerified: true,
        ),
        Borrower(
          id: 3,
          fullName: 'John Banda',
          phone: '+265 777 000 000',
          email: 'john@email.com',
          address: 'Blantyre',
          isVerified: false,
        ),
      ];
    }
  }

  Future<void> addBorrower(Borrower borrower) async {
    try {
      final data = await _api.createBorrower(borrower.toJson());
      final newBorrower = Borrower.fromJson(data);
      state = [...state, newBorrower];
    } catch (e) {
      // Mock add if backend not available
      state = [...state, borrower];
    }
  }
}
