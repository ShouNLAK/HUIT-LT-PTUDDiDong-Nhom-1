import 'package:flutter/material.dart';

import 'candidate_profile_screen.dart';
import 'company_profile_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'splash_screen.dart';

// Chạy module 1: flutter run -t lib/TV1/main.dart
void main() => runApp(const JobConnectApp());

class JobConnectApp extends StatelessWidget {
  const JobConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/profile/candidate': (_) => const CandidateProfileScreen(),
        '/profile/company': (_) => const CompanyProfileScreen(),
      },
    );
  }
}
