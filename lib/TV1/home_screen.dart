import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'models.dart';

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
                child: Text(
                  isCandidate
                      ? 'Trang chủ ứng viên (TV2 phụ trách)'
                      : 'Dashboard nhà tuyển dụng (TV4 phụ trách)',
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
