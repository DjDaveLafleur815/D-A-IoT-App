import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/dashboard_view.dart';
import 'views/contact_view.dart';
import 'views/portfolio_view.dart';

void main() {
  runApp(const DAIoTApp());
}

class DAIoTApp extends StatelessWidget {
  const DAIoTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'D-A-IoT',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      initialRoute: "/login",
      routes: {
        "/": (c) => const HomeView(),
        "/login": (c) => const LoginView(),
        "/register": (c) => const RegisterView(),
        "/dashboard": (c) => const DashboardView(),
        "/contact": (c) => const ContactView(),
        "/portfolio": (c) => const PortfolioView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
