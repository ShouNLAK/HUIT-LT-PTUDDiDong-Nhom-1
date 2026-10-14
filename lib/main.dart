import 'package:flutter/material.dart';
import 'TV1/main.dart';
import 'TV2/main.dart';
import 'TV3/main.dart';
import 'TV4/screens/employer/employer_dashboard_screen.dart';
import 'TV5/screens/candidate_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
        ),
      ),
      home: const MainHubScreen(),
    );
  }
}

class MainHubScreen extends StatelessWidget {
  const MainHubScreen({super.key});

  Widget _buildMemberButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget targetScreen,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color,
          foregroundColor: Colors.white,
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobConnect - Tiến độ các TV'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _buildMemberButton(
            context: context,
            title: 'Thành viên 1 (TV1)',
            subtitle: 'Đăng nhập, Đăng ký & Quản lý hồ sơ',
            icon: Icons.person_outline,
            color: Colors.indigo,
            targetScreen: const JobConnectApp(),
          ),
          _buildMemberButton(
            context: context,
            title: 'Thành viên 2 (TV2)',
            subtitle: 'Tìm kiếm & Khám phá việc làm',
            icon: Icons.search,
            color: Colors.teal,
            targetScreen: const TV2Screen(),
          ),
          _buildMemberButton(
            context: context,
            title: 'Thành viên 3 (TV3)',
            subtitle: 'Đang phát triển',
            icon: Icons.person_outline,
            color: Colors.grey,
            targetScreen: const TV3Screen(),
          ),
          _buildMemberButton(
            context: context,
            title: 'Thành viên 4 (TV4)',
            subtitle: 'Quản lý tin tuyển dụng (Nhà tuyển dụng)',
            icon: Icons.work,
            color: Colors.blue,
            targetScreen: const EmployerDashboardScreen(),
          ),
          _buildMemberButton(
            context: context,
            title: 'Thành viên 5 (TV5)',
            subtitle: 'Xử lý hồ sơ ứng viên (Nhà tuyển dụng)',
            icon: Icons.assignment_ind,
            color: Colors.green,
            targetScreen: const CandidateListScreen(),
          ),
        ],
      ),
    );
  }
}
