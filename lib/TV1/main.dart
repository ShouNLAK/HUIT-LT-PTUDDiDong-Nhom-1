import 'package:flutter/material.dart';

void main() {
  runApp(const TV1App());
}

class TV1App extends StatelessWidget {
  const TV1App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TV1Screen(),
    );
  }
}

class TV1Screen extends StatelessWidget {
  const TV1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thành viên 1'),
      ),
      body: const Center(
        child: Text(
          'Mô-đun của Thành viên 1 đang phát triển',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
