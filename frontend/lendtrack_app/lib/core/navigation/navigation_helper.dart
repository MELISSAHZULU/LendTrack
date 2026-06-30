import 'package:lendtrack_app/core/navigation/navigation_service.dart';
import 'package:lendtrack_app/core/routes/app_routes.dart';

class NavigationHelper {
  static final NavigationService _nav = NavigationService();

  // ============ AUTH ============
  static void goToSplash() => _nav.navigateToReplacement(AppRoutes.splash);
  static void goToLogin() => _nav.navigateToReplacement(AppRoutes.login);
  static void goToDashboard() => _nav.navigateToReplacement(AppRoutes.dashboard);

  // ============ ADMIN ============
  static void goToBorrowers() => _nav.navigateTo(AppRoutes.borrowers);
  static void goToAddBorrower() => _nav.navigateTo(AppRoutes.addBorrower);
  static void goToBorrowerProfile(int borrowerId) => 
      _nav.navigateTo(AppRoutes.borrowerProfile, arguments: borrowerId);
  static void goToLoanApplications() => _nav.navigateTo(AppRoutes.loanApplications);
  static void goToApplyLoan() => _nav.navigateTo(AppRoutes.applyLoan);
  static void goToDisburse() => _nav.navigateTo(AppRoutes.disburse);
  static void goToRequestRepayment() => _nav.navigateTo(AppRoutes.requestRepayment);
  static void goToTransactionHistory() => _nav.navigateTo(AppRoutes.transactionHistory);
  static void goToNotifications() => _nav.navigateTo(AppRoutes.notifications);
  static void goToSettings() => _nav.navigateTo(AppRoutes.settings);

  // ============ BORROWER ============
  static void goToBorrowerDashboard() => _nav.navigateTo(AppRoutes.borrowerDashboard);
  static void goToMyLoans() => _nav.navigateTo(AppRoutes.myLoans);
  static void goToMakePayment() => _nav.navigateTo(AppRoutes.makePayment);

  // ============ UTILITY ============
  static void goBack() => _nav.goBack();
}
