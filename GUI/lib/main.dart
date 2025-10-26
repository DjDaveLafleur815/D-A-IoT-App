import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/dashboard_view.dart';
import 'views/home_view.dart';
import 'views/contact_view.dart';
import 'views/portfolio_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService.I),
      ],
      child: const DAIoTApp(),
    ),
  );
}

class DAIoTApp extends StatelessWidget {
  const DAIoTApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = const Color(0xFF5E60CE);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'D-A IoT',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        snackBarTheme:
            const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      ),
      routes: {
        "/": (_) => const AuthGate(),
        "/login": (_) => const LoginView(),
        "/register": (_) => const RegisterView(),
        "/dashboard": (_) => const DashboardView(),
        "/home": (_) => const HomeView(),
        "/contact": (_) => const ContactView(),
        "/portfolio": (_) => const PortfolioView(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    if (auth.isLoggedIn) {
      return const DashboardView();
    }
    return const LoginView();
  }
}
