import 'package:flutter/material.dart';

import '../models/application_model.dart';

class ApplicationDetailScreen extends StatefulWidget {
  final Application application;

  const ApplicationDetailScreen({Key? key, required this.application})
    : super(key: key);

  @override
  State<ApplicationDetailScreen> createState() =>
      _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends State<ApplicationDetailScreen> {
  Widget _buildFallbackLogo(String companyName) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          companyName.isNotEmpty ? companyName[0].toUpperCase() : 'C',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  void _confirmCancelApplication() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Xác nhận rút đơn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Bạn có chắc chắn muốn rút đơn ứng tuyển này? Thao tác này không thể hoàn tác.',
          style: TextStyle(color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              setState(() {
                mockApplications.removeWhere(
                  (app) => app.id == widget.application.id,
                );
              });
              Navigator.pop(ctx);
              Navigator.pop(context, true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã rút đơn ứng tuyển thành công!'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            child: const Text(
              'Xác nhận rút',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.application;
    final bool canCancel = app.status == ApplicationStatus.pending;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        title: const Text(
          'Chi tiết đơn ứng tuyển',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Công ty
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              app.companyLogo.isNotEmpty &&
                                  app.companyLogo.startsWith('http')
                              ? Image.network(
                                  app.companyLogo,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildFallbackLogo(app.companyName),
                                )
                              : _buildFallbackLogo(app.companyName),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app.jobTitle,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              app.companyName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildJobInfo(
                    icon: Icons.payments_outlined,
                    label: 'Mức lương',
                    value: app.salaryText,
                  ),
                  const SizedBox(height: 10),
                  _buildJobInfo(
                    icon: Icons.place_outlined,
                    label: 'Địa điểm',
                    value: app.location,
                  ),
                  const SizedBox(height: 10),
                  _buildJobInfo(
                    icon: Icons.work_outline,
                    label: 'Hình thức làm việc',
                    value: app.jobType,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ngày nộp: ${app.appliedDate}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: app.status.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          app.status.label,
                          style: TextStyle(
                            color: app.status.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Timeline
            const Text(
              'Tiến trình hồ sơ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildTimelineItem(
                    title: 'Đã nộp đơn ứng tuyển',
                    time: app.appliedDate,
                    isDone: true,
                    isLast: false,
                  ),
                  _buildTimelineItem(
                    title: 'Lịch hẹn phỏng vấn',
                    time:
                        (app.status == ApplicationStatus.interview ||
                            app.status == ApplicationStatus.accepted)
                        ? 'Đã mời phỏng vấn'
                        : 'Chờ phản hồi...',
                    isDone:
                        app.status == ApplicationStatus.interview ||
                        app.status == ApplicationStatus.accepted,
                    isLast: false,
                  ),
                  _buildTimelineItem(
                    title: app.status == ApplicationStatus.rejected
                        ? 'Bị từ chối'
                        : app.status == ApplicationStatus.accepted
                        ? 'Trúng tuyển'
                        : 'Chờ kết quả',
                    time: app.status == ApplicationStatus.accepted
                        ? 'Chúc mừng! Bạn đã trúng tuyển'
                        : (app.status == ApplicationStatus.rejected
                              ? 'Doanh nghiệp đã từ chối'
                              : 'Chờ kết quả...'),
                    isDone:
                        app.status == ApplicationStatus.accepted ||
                        app.status == ApplicationStatus.rejected,
                    isLast: true,
                    isError: app.status == ApplicationStatus.rejected,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // File CV & Cover Letter
            const Text(
              'Hồ sơ đính kèm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.picture_as_pdf,
                    color: Color(0xFFDC2626),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      app.cvFileName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Thư giới thiệu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                app.coverLetter.isNotEmpty
                    ? app.coverLetter
                    : 'Không có thư giới thiệu.',
                style: const TextStyle(
                  color: Color(0xFF334155),
                  height: 1.4,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: canCancel
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _confirmCancelApplication,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFDC2626)),
                      foregroundColor: const Color(0xFFDC2626),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Rút đơn ứng tuyển',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
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

  Widget _buildTimelineItem({
    required String title,
    required String time,
    required bool isDone,
    required bool isLast,
    bool isError = false,
  }) {
    final Color activeColor = isError
        ? const Color(0xFFDC2626)
        : const Color(0xFF16A34A);
    final Color itemColor = isDone ? activeColor : const Color(0xFFCBD5E1);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? itemColor : Colors.white,
                border: Border.all(color: itemColor, width: 2),
              ),
              child: isDone
                  ? Icon(
                      isError ? Icons.close : Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: isDone ? activeColor : const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                  color: isDone
                      ? const Color(0xFF0F172A)
                      : const Color(0xFF64748B),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
              if (!isLast) const SizedBox(height: 14),
            ],
          ),
        ),
      ],
    );
  }
}
