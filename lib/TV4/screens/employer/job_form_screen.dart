import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/job.dart';
import '../../services/job_file_service.dart';
import '../../utils/validators.dart';

class JobFormScreen extends StatefulWidget {
  final Job? job;

  const JobFormScreen({super.key, this.job});

  @override
  State<JobFormScreen> createState() => _JobFormScreenState();
}

class _JobFormScreenState extends State<JobFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fileService = JobFileService();

  late final TextEditingController _titleController;
  late final TextEditingController _companyController;
  late final TextEditingController _locationController;
  late final TextEditingController _salaryMinController;
  late final TextEditingController _salaryMaxController;
  late final TextEditingController _deadlineController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _requirementsController;

  late String _selectedIndustry;
  late String _selectedLevel;
  late String _selectedJobType;
  DateTime? _selectedDeadline;

  bool _isSubmitting = false;
  bool _isFormDirty = false;

  static const List<String> _industryOptions = [
    'Công nghệ thông tin',
    'Tài chính / Ngân hàng',
    'Marketing / Truyền thông',
    'Thiết kế / Sáng tạo',
    'Kinh doanh / Bán hàng',
    'Hành chính / Nhân sự',
    'Khác',
  ];

  static const List<String> _levelOptions = [
    'Thực tập',
    'Nhân viên',
    'Trưởng nhóm',
    'Quản lý',
  ];

  static const List<String> _jobTypeOptions = [
    'Toàn thời gian',
    'Bán thời gian',
    'Thực tập',
    'Remote',
  ];

  @override
  void initState() {
    super.initState();
    final existing = widget.job;

    _titleController = TextEditingController(text: existing?.title ?? '');
    _companyController = TextEditingController(text: existing?.companyName ?? '');
    _locationController = TextEditingController(text: existing?.location ?? '');
    _salaryMinController = TextEditingController(
      text: existing != null ? existing.salaryMin.toString() : '',
    );
    _salaryMaxController = TextEditingController(
      text: existing != null ? existing.salaryMax.toString() : '',
    );
    _selectedDeadline = existing?.deadline;
    _deadlineController = TextEditingController(
      text: existing != null ? DateFormat('dd/MM/yyyy').format(existing.deadline) : '',
    );
    _descriptionController = TextEditingController(text: existing?.description ?? '');
    _requirementsController = TextEditingController(text: existing?.requirements ?? '');

    _selectedIndustry = existing != null && _industryOptions.contains(existing.industry)
        ? existing.industry
        : _industryOptions.first;

    _selectedLevel = existing != null && _levelOptions.contains(existing.level)
        ? existing.level
        : _levelOptions[1];

    _selectedJobType = existing != null && _jobTypeOptions.contains(existing.jobType)
        ? existing.jobType
        : _jobTypeOptions.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    _deadlineController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_isFormDirty) {
      setState(() {
        _isFormDirty = true;
      });
    }
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final initialDate = _selectedDeadline != null && _selectedDeadline!.isAfter(now)
        ? _selectedDeadline!
        : now.add(const Duration(days: 14));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDeadline = pickedDate;
        _deadlineController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        _isFormDirty = true;
      });
      _formKey.currentState?.validate();
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn hạn chót nộp hồ sơ!')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final isEditing = widget.job != null;
      final now = DateTime.now();

      final jobToSave = Job(
        id: isEditing ? widget.job!.id : now.millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        companyName: _companyController.text.trim(),
        location: _locationController.text.trim(),
        industry: _selectedIndustry,
        level: _selectedLevel,
        jobType: _selectedJobType,
        salaryMin: int.parse(_salaryMinController.text.trim()),
        salaryMax: int.parse(_salaryMaxController.text.trim()),
        description: _descriptionController.text.trim(),
        requirements: _requirementsController.text.trim(),
        deadline: _selectedDeadline!,
        createdAt: isEditing ? widget.job!.createdAt : now,
        status: isEditing ? widget.job!.status : JobStatus.open,
        applicantCount: isEditing ? widget.job!.applicantCount : 0,
      );

      if (isEditing) {
        await _fileService.updateJob(jobToSave);
      } else {
        await _fileService.addJob(jobToSave);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Đã cập nhật tin tuyển dụng thành công!'
                : 'Đã đăng tin tuyển dụng mới thành công!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<bool> _confirmDiscard() async {
    if (!_isFormDirty) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận thoát'),
        content: const Text('Bạn có thay đổi chưa lưu. Bạn có muốn thoát không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Ở lại'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Thoát', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.job != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Chỉnh sửa tin tuyển dụng' : 'Đăng tin tuyển dụng mới'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            final leave = await _confirmDiscard();
            if (leave && context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề công việc *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: FormValidators.validateTitle,
              onChanged: (_) => _onFieldChanged(),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Tên công ty tuyển dụng *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              validator: (v) => FormValidators.validateRequired(v, 'Tên công ty'),
              onChanged: (_) => _onFieldChanged(),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Địa điểm làm việc *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (v) => FormValidators.validateRequired(v, 'Địa điểm'),
              onChanged: (_) => _onFieldChanged(),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _selectedIndustry,
              decoration: const InputDecoration(
                labelText: 'Ngành nghề *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _industryOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedIndustry = val);
                  _onFieldChanged();
                }
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedLevel,
                    decoration: const InputDecoration(
                      labelText: 'Cấp bậc *',
                      border: OutlineInputBorder(),
                    ),
                    items: _levelOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedLevel = val);
                        _onFieldChanged();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedJobType,
                    decoration: const InputDecoration(
                      labelText: 'Hình thức *',
                      border: OutlineInputBorder(),
                    ),
                    items: _jobTypeOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedJobType = val);
                        _onFieldChanged();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _salaryMinController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Lương tối thiểu (triệu) *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => FormValidators.validateSalary(v, 'Lương tối thiểu'),
                    onChanged: (_) => _onFieldChanged(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _salaryMaxController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Lương tối đa (triệu) *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final basicCheck = FormValidators.validateSalary(v, 'Lương tối đa');
                      if (basicCheck != null) return basicCheck;
                      return FormValidators.validateSalaryRange(_salaryMinController.text, v);
                    },
                    onChanged: (_) => _onFieldChanged(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _deadlineController,
              readOnly: true,
              onTap: _pickDeadline,
              decoration: const InputDecoration(
                labelText: 'Hạn nộp hồ sơ (dd/MM/yyyy) *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              validator: (_) => FormValidators.validateDeadline(_selectedDeadline),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Mô tả công việc (tối thiểu 30 ký tự) *',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: FormValidators.validateDescription,
              onChanged: (_) => _onFieldChanged(),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _requirementsController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Yêu cầu ứng viên (tối thiểu 10 ký tự) *',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: FormValidators.validateRequirements,
              onChanged: (_) => _onFieldChanged(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  _isSubmitting
                      ? 'Đang lưu...'
                      : (isEditing ? 'LƯU THAY ĐỔI' : 'ĐĂNG TIN'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
