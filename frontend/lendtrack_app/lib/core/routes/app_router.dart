import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lendtrack_app/presentation/screens/auth/login_screen.dart';
import 'package:lendtrack_app/presentation/screens/auth/splash_screen.dart';
import 'package:lendtrack_app/presentation/screens/admin/dashboard/admin_dashboard.dart';
import 'package:lendtrack_app/presentation/screens/borrower/borrower_dashboard.dart';
import 'package:lendtrack_app/state/auth_state.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final userRole = authState.user?.role;

      // If not authenticated, go to login (except for splash)
      if (!isAuthenticated && state.uri.path != '/splash') {
        return '/login';
      }

      // If authenticated, redirect based on role
      if (isAuthenticated) {
        if (state.uri.path == '/splash' || state.uri.path == '/login') {
          if (userRole == 'admin') {
            return '/admin/dashboard';
          } else {
            return '/borrower/dashboard';
          }
        }
      }

      return null;
    },
    routes: [
      // Public routes
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Admin routes
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboard(),
      ),

      // Borrower routes
      GoRoute(
        path: '/borrower/dashboard',
        builder: (context, state) => const BorrowerDashboard(),
      ),
    ],
  );
});
