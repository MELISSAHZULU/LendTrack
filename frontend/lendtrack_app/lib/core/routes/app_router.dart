import 'package:flutter/material.dart';
import 'package:lendtrack_app/core/routes/app_routes.dart';
import 'package:lendtrack_app/presentation/screens/auth/splash_screen.dart';
import 'package:lendtrack_app/presentation/screens/auth/login_screen.dart';
import 'package:lendtrack_app/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:lendtrack_app/presentation/screens/borrowers_list.dart';
import 'package:lendtrack_app/presentation/screens/add_borrower.dart';
import 'package:lendtrack_app/presentation/screens/borrower_profile.dart';
import 'package:lendtrack_app/presentation/screens/loan_applications.dart';
import 'package:lendtrack_app/presentation/screens/borrower_loan_application.dart';
import 'package:lendtrack_app/presentation/screens/disburse_loan.dart';
import 'package:lendtrack_app/presentation/screens/request_repayment.dart';
import 'package:lendtrack_app/presentation/screens/transaction_history.dart';
import 'package:lendtrack_app/presentation/screens/notifications.dart';
import 'package:lendtrack_app/presentation/screens/settings.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      
      case AppRoutes.borrowers:
        return MaterialPageRoute(builder: (_) => const BorrowersListScreen());
      
      case AppRoutes.addBorrower:
        return MaterialPageRoute(builder: (_) => const AddBorrowerScreen());
      
      case AppRoutes.borrowerProfile:
        final args = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => BorrowerProfileScreen(borrowerId: args ?? 0),
        );
      
      case AppRoutes.loanApplications:
        return MaterialPageRoute(builder: (_) => const LoanApplicationsScreen());
      
      case AppRoutes.applyLoan:
        return MaterialPageRoute(builder: (_) => const BorrowerLoanApplicationScreen());
      
      case AppRoutes.disburse:
        return MaterialPageRoute(builder: (_) => const DisburseLoanScreen());
      
      case AppRoutes.requestRepayment:
        return MaterialPageRoute(builder: (_) => const RequestRepaymentScreen());
      
      case AppRoutes.transactionHistory:
        return MaterialPageRoute(builder: (_) => const TransactionHistoryScreen());
      
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
