import 'package:flutter/material.dart';

void main() {
  runApp(const TV2App());
}

class TV2App extends StatelessWidget {
  const TV2App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TV2Screen(),
    );
  }
}

class TV2Screen extends StatelessWidget {
  const TV2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thành viên 2'),
      ),
      body: const Center(
        child: Text(
          'Mô-đun của Thành viên 2 đang phát triển',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
