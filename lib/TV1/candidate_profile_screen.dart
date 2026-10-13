import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'models.dart';
import 'validators.dart';

class CandidateProfileScreen extends StatefulWidget {
  const CandidateProfileScreen({super.key});

  @override
  State<CandidateProfileScreen> createState() => _CandidateProfileScreenState();
}

class _CandidateProfileScreenState extends State<CandidateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _position = TextEditingController();
  final _skills = TextEditingController();
  String? _cvFileName;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    if (user != null) {
      final p = AuthService.instance.candidateProfile(user.id);
      _phone.text = p.phone;
      _position.text = p.position;
      _skills.text = p.skills;
      _cvFileName = p.cvFileName;
    }
  }

  @override
  void dispose() {
    _phone.dispose();
    _position.dispose();
    _skills.dispose();
    super.dispose();
  }

  String? _validatePhone(String? v) {
    final empty = Validators.required(v, 'Số điện thoại');
    if (empty != null) return empty;
    if (!RegExp(r'^0\d{9}$').hasMatch(v!.trim())) {
      return 'Số điện thoại phải gồm 10 số, bắt đầu bằng 0';
    }
    return null;
  }

  // Giả lập chọn file; giai đoạn 2 dùng file_picker và Firebase Storage.
  Future<void> _pickCv(AppUser user) async {
    final names = [
      'CV_${user.name.split(' ').last}.pdf',
      'CV_TiengAnh.pdf',
      'CV_ThucTap.pdf',
    ];
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Chọn CV',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            for (final n in names)
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(n),
                onTap: () => Navigator.pop(ctx, n),
              ),
          ],
        ),
      ),
    );
    if (picked != null && mounted) setState(() => _cvFileName = picked);
  }

  // Chưa đọc được file thật nên hiển thị bản CV dựng từ thông tin hồ sơ.
  void _previewCv(AppUser user) {
    String orDash(String v) => v.trim().isEmpty ? '-' : v.trim();
    showDialog<void>(
      context: context,
      builder: (ctx) {
        final text = Theme.of(ctx).textTheme;
        return AlertDialog(
          title: Text(_cvFileName ?? 'CV'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(user.name, style: text.titleLarge),
                Text(orDash(_position.text), style: text.titleSmall),
                const Divider(height: 24),
                Text('Email: ${user.email}'),
                Text('Điện thoại: ${orDash(_phone.text)}'),
                const SizedBox(height: 12),
                Text('Kỹ năng', style: text.titleSmall),
                Text(orDash(_skills.text)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _save(AppUser user) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final profile = CandidateProfile(
      phone: _phone.text.trim(),
      position: _position.text.trim(),
      skills: _skills.text.trim(),
      cvFileName: _cvFileName,
    );
    await AuthService.instance.saveCandidateProfile(user.id, profile);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Đã lưu hồ sơ')));
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Chưa đăng nhập')));
    }
    final scheme = Theme.of(context).colorScheme;
    final initial = user.name.trim().isEmpty
        ? '?'
        : user.name.trim()[0].toUpperCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ ứng viên')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: scheme.primaryContainer,
                  child: Text(initial, style: const TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                user.email,
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.outline),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: _validatePhone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _position,
                decoration: const InputDecoration(
                  labelText: 'Vị trí mong muốn',
                  prefixIcon: Icon(Icons.work_outline),
                ),
                validator: (v) => Validators.required(v, 'Vị trí mong muốn'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _skills,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Kỹ năng',
                  prefixIcon: Icon(Icons.lightbulb_outline),
                  helperText: 'Ví dụ: Flutter, Dart, Firebase',
                ),
              ),
              const SizedBox(height: 16),
              Card.outlined(
                child: ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(_cvFileName ?? 'Chưa có CV'),
                  subtitle: _cvFileName == null
                      ? const Text('Chỉ nhận file PDF')
                      : null,
                  trailing: _cvFileName == null
                      ? TextButton(
                          onPressed: () => _pickCv(user),
                          child: const Text('Chọn CV'),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => _previewCv(user),
                              child: const Text('Xem'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: 'Xóa CV',
                              onPressed: () =>
                                  setState(() => _cvFileName = null),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _saving ? null : () => _save(user),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Lưu hồ sơ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
