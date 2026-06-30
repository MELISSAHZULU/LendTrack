import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lendtrack_app/core/routes/app_router.dart';
import 'package:lendtrack_app/core/routes/app_routes.dart';
import 'package:lendtrack_app/core/navigation/navigation_service.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LendTrack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      navigatorKey: NavigationService().navigatorKey,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRoutes.splash,
      debugShowCheckedModeBanner: false,
    );
  }
}
