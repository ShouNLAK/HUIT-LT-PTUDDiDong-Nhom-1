import '../models/candidate_model.dart';
import '../services/candidate_service.dart';
import '../services/candidate_file_service.dart';
import 'package:flutter/material.dart';


class CandidateListScreen extends StatefulWidget {
  final String jobTitle;

  const CandidateListScreen({
    super.key,
    this.jobTitle = 'Lập trình viên Flutter (Mobile App)',
  });

  @override
  State<CandidateListScreen> createState() => _CandidateListScreenState();
}

class _CandidateListScreenState extends State<CandidateListScreen> {
  final _fileService = CandidateFileService();
  String _selectedFilter = 'Tất cả';
  bool _isLoading = true;
  List<ApplicantModel> _applicants = [];

  final List<String> _filterOptions = [
    'Tất cả',
    'Đang chờ',
    'Phỏng vấn',
    'Trúng tuyển',
    'Từ chối',
  ];

  @override
  void initState() {
    super.initState();
    AppService.initNotifications();
    _loadApplicants();
  }

  Future<void> _loadApplicants() async {
    setState(() => _isLoading = true);
    try {
      final all = await _fileService.getAllApplicants();
      if (!mounted) return;
      setState(() {
        if (widget.jobTitle.isEmpty || widget.jobTitle == 'Tất cả vị trí tuyển dụng') {
          _applicants = all;
        } else {
          _applicants = all.where((a) {
            final appPos = a.appliedPosition.toLowerCase().trim();
            final searchPos = widget.jobTitle.toLowerCase().trim();
            return appPos == searchPos ||
                appPos.contains(searchPos) ||
                searchPos.contains(appPos);
          }).toList();
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handlePickCv(ApplicantModel applicant) async {
    String? fileName = await AppService.pickCvFile();
    if (fileName != null) {
      final updated = applicant.copyWith(cvFileName: fileName);
      await _fileService.updateApplicant(updated);
      await _loadApplicants();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã cập nhật CV: $fileName')),
      );
    }
  }

  Future<void> _handleUpdateStatus(ApplicantModel applicant, ApplicationStatus newStatus) async {
    final updated = applicant.copyWith(status: newStatus);
    await _fileService.updateApplicant(updated);
    await _loadApplicants();
    AppService.showLocalNotification(
      'Cập nhật trạng thái ứng viên',
      'Hồ sơ của ${applicant.name} đã chuyển sang: ${newStatus.label}',
    );
  }

  Future<void> _handleDeleteApplicant(ApplicantModel applicant) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa hồ sơ của ${applicant.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _fileService.deleteApplicant(applicant.id);
      await _loadApplicants();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xóa hồ sơ của ${applicant.name}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<ApplicantModel> get _filteredApplicants {
    if (_selectedFilter == 'Tất cả') {
      return _applicants;
    }
    return _applicants.where((a) => a.status.label == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Danh sách ứng viên',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.jobTitle} (${_applicants.length} hồ sơ)',
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildFilterBar(),
                Expanded(
                  child: _filteredApplicants.isEmpty
                      ? const Center(child: Text('Chưa có ứng viên nào'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _filteredApplicants.length,
                          itemBuilder: (context, index) {
                            final applicant = _filteredApplicants[index];
                            return _buildApplicantCard(applicant);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final option = _filterOptions[index];
          final isSelected = option == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(option),
              selected: isSelected,
              selectedColor: Colors.blueAccent,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedFilter = option;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildApplicantCard(ApplicantModel applicant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blueAccent.shade100,
                  child: Text(
                    applicant.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicant.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        applicant.appliedPosition,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Nộp ngày: ${applicant.appliedDate}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: applicant.status.color.withAlpha(38),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    applicant.status.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: applicant.status.color,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    applicant.cvFileName != null
                        ? 'CV: ${applicant.cvFileName}'
                        : 'Chưa đính kèm CV',
                    style: TextStyle(
                      fontSize: 13,
                      color: applicant.cvFileName != null ? Colors.blue : Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, size: 20),
                  onPressed: () => _handlePickCv(applicant),
                  tooltip: 'Chọn/Thay đổi tệp CV',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                  tooltip: 'Xóa hồ sơ',
                  onPressed: () => _handleDeleteApplicant(applicant),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () => _handleUpdateStatus(applicant, ApplicationStatus.interview),
                  child: const Text('Hẹn phỏng vấn', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _handleUpdateStatus(applicant, ApplicationStatus.accepted),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Nhận', style: TextStyle(fontSize: 12, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}