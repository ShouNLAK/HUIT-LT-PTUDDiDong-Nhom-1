import 'package:flutter/material.dart';
import 'package:huit_lt_ptuddidong_nhom_1/TV3/application/screens/application_list_screen.dart';
void main() {
  runApp(const TV3App());
}

class TV3App extends StatelessWidget {
  const TV3App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TV3Screen(),
    );
  }
}

class TV3Screen extends StatelessWidget {
  const TV3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ApplicationListScreen();
  }
}
