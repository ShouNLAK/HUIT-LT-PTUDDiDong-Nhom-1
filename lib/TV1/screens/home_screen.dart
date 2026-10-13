import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import '../../TV4/screens/employer/employer_dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Chưa đăng nhập')));
    }

    final isCandidate = user.role == UserRole.candidate;
    final profileRoute = isCandidate
        ? '/profile/candidate'
        : '/profile/company';

    return Scaffold(
      appBar: AppBar(
        leading: Navigator.of(context, rootNavigator: true).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Về trang chủ nhóm',
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              )
            : null,
        title: const Text('JobConnect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Hồ sơ',
            onPressed: () => Navigator.pushNamed(context, profileRoute),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              AuthService.instance.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Xin chào, ${user.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(label: Text('Vai trò: ${user.role.label}')),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCandidate
                          ? 'Trang chủ ứng viên (TV2 phụ trách)'
                          : 'Bảng điều khiển tuyển dụng (TV4 phụ trách)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isCandidate
                          ? 'Khu vực tìm kiếm việc làm, xem chi tiết và ứng tuyển công việc.'
                          : 'Khu vực đăng tin, quản lý tin tuyển dụng và xem hồ sơ ứng viên.',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    if (!isCandidate) ...[
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.dashboard),
                        label: const Text('Vào Dashboard Nhà tuyển dụng (TV4)'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmployerDashboardScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => Navigator.pushNamed(context, profileRoute),
              child: const Text('Cập nhật hồ sơ'),
            ),
          ],
        ),
      ),
    );
  }
}
