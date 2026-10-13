import 'package:flutter/material.dart';
import 'screens/candidate_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TV5App());
}

class TV5App extends StatelessWidget {
  const TV5App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CandidateListScreen(),
    );
  }
}
