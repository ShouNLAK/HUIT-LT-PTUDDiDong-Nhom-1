import 'package:flutter/material.dart';
import 'screens/explore/home_screen.dart';

void main() {
  runApp(const TV2App());
}

class TV2App extends StatelessWidget {
  const TV2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobConnect - TV2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
      ),
      home: const HomeScreen(),
    );
  }
}

class TV2Screen extends StatelessWidget {
  const TV2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
