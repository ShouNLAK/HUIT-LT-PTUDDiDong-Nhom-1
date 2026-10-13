import 'package:flutter/material.dart';

import 'candidate_profile_screen.dart';
import 'company_profile_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'splash_screen.dart';

// Chạy riêng module 1: flutter run -t lib/TV1/main.dart
void main() => runApp(const JobConnectApp());

final _theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);

final _routes = <String, WidgetBuilder>{
  '/': (_) => const SplashScreen(),
  '/login': (_) => const LoginScreen(),
  '/register': (_) => const RegisterScreen(),
  '/home': (_) => const HomeScreen(),
  '/profile/candidate': (_) => const CandidateProfileScreen(),
  '/profile/company': (_) => const CompanyProfileScreen(),
};

class JobConnectApp extends StatelessWidget {
  const JobConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobConnect',
      debugShowCheckedModeBanner: false,
      theme: _theme,
      initialRoute: '/',
      routes: _routes,
    );
  }
}

// Màn mở từ menu chung ở lib/main.dart. Module chạy trong Navigator riêng
// để các route có tên của TV1 không phụ thuộc MaterialApp của menu.
class TV1Screen extends StatefulWidget {
  const TV1Screen({super.key});

  @override
  State<TV1Screen> createState() => _TV1ScreenState();
}

class _TV1ScreenState extends State<TV1Screen> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPopWithResult: (_) => _navigatorKey.currentState!.maybePop(),
      child: Theme(
        data: _theme,
        child: Navigator(
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: _routes[settings.name] ?? _routes['/login']!,
            settings: settings,
          ),
        ),
      ),
    );
  }
}
