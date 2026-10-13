import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'models.dart';
import 'validators.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _website = TextEditingController();
  final _description = TextEditingController();
  String? _industry;
  String? _size;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    if (user != null) {
      final p = AuthService.instance.companyProfile(user.id);
      _name.text = p.name;
      _industry = p.industry;
      _size = p.size;
      _address.text = p.address;
      _website.text = p.website;
      _description.text = p.description;
    }
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _website.dispose();
    _description.dispose();
    super.dispose();
  }

  String? _validateWebsite(String? v) {
    final text = v?.trim() ?? '';
    if (text.isEmpty) return null;
    if (!text.startsWith('http://') && !text.startsWith('https://')) {
      return 'Website phải bắt đầu bằng http:// hoặc https://';
    }
    return null;
  }

  Future<void> _save(AppUser user) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final profile = CompanyProfile(
      name: _name.text.trim(),
      industry: _industry,
      size: _size,
      address: _address.text.trim(),
      website: _website.text.trim(),
      description: _description.text.trim(),
    );
    await AuthService.instance.saveCompanyProfile(user.id, profile);
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
    final label = _name.text.trim().isNotEmpty
        ? _name.text.trim()
        : user.name.trim();
    final initial = label.isEmpty ? '?' : label[0].toUpperCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ công ty')),
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
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Tên công ty',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
                validator: (v) => Validators.required(v, 'Tên công ty'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _industry,
                decoration: const InputDecoration(
                  labelText: 'Lĩnh vực',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: [
                  for (final i in industries)
                    DropdownMenuItem(
                      value: i,
                      child: Text(i, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (v) => setState(() => _industry = v),
                validator: (v) => v == null ? 'Vui lòng chọn lĩnh vực' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _size,
                decoration: const InputDecoration(
                  labelText: 'Quy mô',
                  prefixIcon: Icon(Icons.groups_outlined),
                ),
                items: [
                  for (final s in companySizes)
                    DropdownMenuItem(
                      value: s,
                      child: Text(s, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (v) => setState(() => _size = v),
                validator: (v) => v == null ? 'Vui lòng chọn quy mô' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (v) => Validators.required(v, 'Địa chỉ'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _website,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Website',
                  prefixIcon: Icon(Icons.language),
                ),
                validator: _validateWebsite,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _description,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Mô tả công ty',
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
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
