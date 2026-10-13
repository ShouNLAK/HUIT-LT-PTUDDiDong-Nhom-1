import 'package:flutter/material.dart';
import '../../models/job.dart';
import '../../services/job_file_service.dart';
import 'job_form_screen.dart';
import '../../../TV5/screens/candidate_screen.dart';

class JobDetailEmployerScreen extends StatefulWidget {
  final Job job;

  const JobDetailEmployerScreen({super.key, required this.job});

  @override
  State<JobDetailEmployerScreen> createState() => _JobDetailEmployerScreenState();
}

class _JobDetailEmployerScreenState extends State<JobDetailEmployerScreen> {
  late Job _job;
  final _fileService = JobFileService();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _job = widget.job;
  }

  Future<void> _refreshJobData() async {
    try {
      final jobs = await _fileService.getAllJobs();
      final updated = jobs.firstWhere(
        (j) => j.id == _job.id,
        orElse: () => _job,
      );
      if (mounted) {
        setState(() {
          _job = updated;
        });
      }
    } catch (_) {}
  }

  Future<void> _toggleStatus() async {
    try {
      await _fileService.toggleStatus(_job.id);
      _hasChanges = true;
      await _refreshJobData();

      if (!mounted) return;
      final isOpen = _job.status == JobStatus.open;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isOpen ? 'Đã mở lại tin tuyển dụng!' : 'Đã đóng tin tuyển dụng!',
          ),
          backgroundColor: isOpen ? Colors.green : Colors.grey[800],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _editJob() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => JobFormScreen(job: _job),
      ),
    );

    if (result == true) {
      _hasChanges = true;
      await _refreshJobData();
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa tin tuyển dụng "${_job.title}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _fileService.deleteJob(_job.id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa tin tuyển dụng thành công!'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết tin tuyển dụng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _hasChanges),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Chỉnh sửa',
            onPressed: _editJob,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Xóa tin',
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMainInfoCard(),
          const SizedBox(height: 14),
          _buildApplicantsCard(),
          const SizedBox(height: 14),
          _buildOverviewGrid(),
          const SizedBox(height: 14),
          _buildContentCard('Mô tả công việc', _job.description, Icons.description),
          const SizedBox(height: 14),
          _buildContentCard('Yêu cầu ứng viên', _job.requirements, Icons.checklist),
          const SizedBox(height: 24),
          _buildBottomActionButtons(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMainInfoCard() {
    final isOpen = _job.status == JobStatus.open;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _job.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.business, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _job.companyName,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  avatar: Icon(
                    isOpen ? Icons.check_circle : Icons.lock,
                    size: 16,
                    color: isOpen ? Colors.green[800] : Colors.grey[800],
                  ),
                  label: Text(
                    _job.statusDisplay,
                    style: TextStyle(
                      color: isOpen ? Colors.green[800] : Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: isOpen ? Colors.green[50] : Colors.grey[200],
                ),
                if (_job.isExpired)
                  Chip(
                    avatar: const Icon(Icons.warning, size: 16, color: Colors.red),
                    label: const Text(
                      'Đã hết hạn nộp',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.red[50],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicantsCard() {
    return Card(
      elevation: 2,
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.people, color: Colors.blue, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Số hồ sơ đã nhận',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  Text(
                    '${_job.applicantCount} ứng viên',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CandidateListScreen(
                      jobTitle: _job.title,
                    ),
                  ),
                );
                final all = await _fileService.getAllJobs();
                final current = all.firstWhere((j) => j.id == _job.id, orElse: () => _job);
                if (mounted) {
                  setState(() {
                    _job = current;
                    _hasChanges = true;
                  });
                }
              },
              child: const Text('Xem hồ sơ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewGrid() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow(Icons.attach_money, 'Mức lương', _job.salaryDisplay, isBold: true),
            const Divider(height: 20),
            _buildDetailRow(Icons.location_on, 'Địa điểm', _job.location),
            const Divider(height: 20),
            _buildDetailRow(Icons.category, 'Ngành nghề', _job.industry),
            const Divider(height: 20),
            _buildDetailRow(Icons.workspace_premium, 'Cấp bậc', _job.level),
            const Divider(height: 20),
            _buildDetailRow(Icons.schedule, 'Hình thức', _job.jobType),
            const Divider(height: 20),
            _buildDetailRow(Icons.calendar_today, 'Hạn nộp hồ sơ', _job.deadlineDisplay),
            const Divider(height: 20),
            _buildDetailRow(Icons.event_available, 'Ngày đăng tin', _job.createdAtDisplay),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isBold = false}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: Colors.black54)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? Colors.green : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildContentCard(String title, String content, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(content, style: const TextStyle(height: 1.5, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionButtons() {
    final isOpen = _job.status == JobStatus.open;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _toggleStatus,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(isOpen ? 'Đóng tin' : 'Mở lại tin'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _editJob,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Chỉnh sửa'),
          ),
        ),
      ],
    );
  }
}
