import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/data/models/loan.dart';
import 'package:lendtrack_app/data/services/api_service.dart';

final loanProvider = StateNotifierProvider<LoanNotifier, List<Loan>>((ref) {
  return LoanNotifier();
});

class LoanNotifier extends StateNotifier<List<Loan>> {
  LoanNotifier() : super([]);

  final ApiService _api = ApiService();

  Future<void> loadLoans() async {
    try {
      final data = await _api.getLoans();
      state = data.map((json) => Loan.fromJson(json)).toList();
    } catch (e) {
      // Mock data if backend not available
      state = [
        Loan(
          id: 1,
          borrowerId: 1,
          borrowerName: 'Chisomo Banda',
          amount: 500000,
          interestRate: 10,
          termMonths: 6,
          outstandingBalance: 230000,
          status: 'active',
          purpose: 'Business expansion',
          dueDate: '2024-01-31',
        ),
        Loan(
          id: 2,
          borrowerId: 2,
          borrowerName: 'Thandiwe Phiri',
          amount: 800000,
          interestRate: 12,
          termMonths: 12,
          outstandingBalance: 460000,
          status: 'active',
          purpose: 'Education',
          dueDate: '2024-06-15',
        ),
        Loan(
          id: 3,
          borrowerId: 1,
          borrowerName: 'Chisomo Banda',
          amount: 300000,
          interestRate: 8,
          termMonths: 3,
          outstandingBalance: 0,
          status: 'completed',
          purpose: 'Home improvement',
          dueDate: '2023-12-15',
        ),
        Loan(
          id: 4,
          borrowerId: 3,
          borrowerName: 'Mary Mwale',
          amount: 150000,
          interestRate: 15,
          termMonths: 4,
          outstandingBalance: 150000,
          status: 'pending',
          purpose: 'Medical expenses',
          dueDate: '2024-07-20',
        ),
      ];
    }
  }

  Future<void> addLoan(Loan loan) async {
    try {
      final data = await _api.createLoan(loan.toJson());
      final newLoan = Loan.fromJson(data);
      state = [...state, newLoan];
    } catch (e) {
      // Mock add if backend not available
      state = [...state, loan];
    }
  }

  Future<void> updateLoanStatus(int loanId, String newStatus) async {
    final index = state.indexWhere((loan) => loan.id == loanId);
    if (index != -1) {
      final loan = state[index];
      final updatedLoan = Loan(
        id: loan.id,
        borrowerId: loan.borrowerId,
        borrowerName: loan.borrowerName,
        amount: loan.amount,
        interestRate: loan.interestRate,
        termMonths: loan.termMonths,
        outstandingBalance: loan.outstandingBalance,
        status: newStatus,
        purpose: loan.purpose,
        dueDate: loan.dueDate,
        createdAt: loan.createdAt,
      );
      state = [
        ...state.sublist(0, index),
        updatedLoan,
        ...state.sublist(index + 1),
      ];
    }
  }
}
