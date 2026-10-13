import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thành viên 3'),
      ),
      body: const Center(
        child: Text(
          'Mô-đun của Thành viên 3 đang phát triển',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
