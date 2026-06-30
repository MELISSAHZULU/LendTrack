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
      if (data.isNotEmpty) {
        state = data.map((json) => Borrower.fromJson(json)).toList();
        print('✅ Loaded ${state.length} borrowers from backend');
      } else {
        // If no data, keep empty state
        state = [];
        print('⚠️ No borrowers found');
      }
    } catch (e) {
      print('❌ Error loading borrowers: $e');
      state = [];
    }
  }

  Future<bool> addBorrower(Borrower borrower) async {
    try {
      print('📝 Adding borrower: ${borrower.fullName}');
      final data = await _api.createBorrower(borrower.toJson());
      final newBorrower = Borrower.fromJson(data);
      
      // Add to state
      state = [...state, newBorrower];
      print('✅ Borrower added! Total: ${state.length}');
      return true;
    } catch (e) {
      print('❌ Error adding borrower: $e');
      return false;
    }
  }

  Future<bool> verifyBorrower(int id) async {
    try {
      final index = state.indexWhere((b) => b.id == id);
      if (index != -1) {
        final borrower = state[index];
        final verifiedBorrower = borrower.copyWith(
          isVerified: true,
          status: 'verified',
        );
        state = [
          ...state.sublist(0, index),
          verifiedBorrower,
          ...state.sublist(index + 1),
        ];
        print('✅ Borrower verified: ${borrower.fullName}');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Error verifying borrower: $e');
      return false;
    }
  }

  Future<Borrower?> getBorrowerById(int id) async {
    try {
      // First try current state
      try {
        return state.firstWhere((b) => b.id == id);
      } catch (e) {
        // If not found, reload and try again
        await loadBorrowers();
        try {
          return state.firstWhere((b) => b.id == id);
        } catch (e) {
          return null;
        }
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> refreshBorrowers() async {
    await loadBorrowers();
  }
}
