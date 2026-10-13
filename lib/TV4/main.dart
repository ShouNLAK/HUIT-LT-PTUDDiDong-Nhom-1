import 'package:flutter/material.dart';
import 'screens/employer/employer_dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JobConnectEmployerApp());
}

class JobConnectEmployerApp extends StatelessWidget {
  const JobConnectEmployerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobConnect - Tuyển dụng',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 1.5,
        ),
      ),
      home: const EmployerDashboardScreen(),
    );
  }
}
