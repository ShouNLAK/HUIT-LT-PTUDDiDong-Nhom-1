import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../models/application_model.dart';

class ApplicationFormScreen extends StatefulWidget {
  final String jobTitle;
  final String companyName;
  final String salaryText;
  final String location;
  final String jobType;

  const ApplicationFormScreen({
    Key? key,
    required this.jobTitle,
    required this.companyName,
    this.salaryText = '',
    this.location = '',
    this.jobType = '',
  }) : super(key: key);

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _coverLetterController = TextEditingController();
  String? _selectedFileName;

  Future<void> _pickCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
      });
    }
  }

  void _submitApplication() {
    // 1. Kiểm tra chọn file CV
    if (_selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn file CV của bạn!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 2. RÀNG BUỘC: Kiểm tra xem đã ứng tuyển công việc này chưa
    final bool isAlreadyApplied = mockApplications.any(
      (app) =>
          app.jobTitle == widget.jobTitle &&
          app.companyName == widget.companyName,
    );

    if (isAlreadyApplied) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Thông báo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Bạn đã nộp đơn ứng tuyển vị trí "${widget.jobTitle}" tại ${widget.companyName} trước đó rồi!',
            style: const TextStyle(color: Color(0xFF475569)),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Đã hiểu',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // 3. Tiến hành lưu đơn nếu chưa từng nộp
    if (_formKey.currentState!.validate()) {
      final newApp = Application(
        id: 'APP${DateTime.now().millisecondsSinceEpoch}',
        jobTitle: widget.jobTitle,
        companyName: widget.companyName,
        companyLogo: '',
        salaryText: widget.salaryText,
        location: widget.location,
        jobType: widget.jobType,
        appliedDate:
            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        status: ApplicationStatus.pending,
        cvFileName: _selectedFileName!,
        coverLetter: _coverLetterController.text,
      );

      mockApplications.insert(0, newApp);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ứng tuyển thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        title: const Text(
          'Nộp đơn ứng tuyển',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.jobTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.companyName,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildJobInfo(
                      icon: Icons.payments_outlined,
                      label: 'Mức lương',
                      value: widget.salaryText,
                    ),
                    const SizedBox(height: 10),
                    _buildJobInfo(
                      icon: Icons.place_outlined,
                      label: 'Địa điểm',
                      value: widget.location,
                    ),
                    const SizedBox(height: 10),
                    _buildJobInfo(
                      icon: Icons.work_outline,
                      label: 'Hình thức làm việc',
                      value: widget.jobType,
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),
              const Text(
                'Hồ sơ CV (PDF, DOCX)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickCV,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.upload_file, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedFileName ?? 'Nhấn vào đây để tải CV',
                          style: TextStyle(
                            color: _selectedFileName == null
                                ? Colors.grey
                                : Colors.black,
                            fontWeight: _selectedFileName == null
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Thư giới thiệu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _coverLetterController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Nhập lý do bạn phù hợp...',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Vui lòng nhập thư giới thiệu'
                    : null,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _submitApplication,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text(
            'Nộp đơn ứng tuyển',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildJobInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : 'Chưa cập nhật',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
