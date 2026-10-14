import 'package:flutter/material.dart';
import '../../models/job.dart';
import '../../services/saved_jobs_store.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;
  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết việc làm')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: cs.primaryContainer,
              child: Text(job.company[0],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimaryContainer)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(job.company, style: TextStyle(color: cs.outline)),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _info(Icons.payments_outlined, 'Mức lương', '${job.salaryText}/tháng'),
          _info(Icons.place_outlined, 'Địa điểm', job.location),
          _info(Icons.category_outlined, 'Ngành', job.industry),
          _info(Icons.trending_up, 'Cấp bậc', job.level),
          _info(Icons.schedule, 'Hình thức', job.jobType),
          _info(Icons.event_outlined, 'Hạn nộp', job.deadlineText),
          const Divider(height: 32),
          const Text('Mô tả công việc',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(job.description, style: const TextStyle(height: 1.5)),
          const SizedBox(height: 16),
          const Text('Yêu cầu ứng viên',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(job.requirements, style: const TextStyle(height: 1.5)),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            ValueListenableBuilder<Set<String>>(
              valueListenable: SavedJobsStore.savedIds,
              builder: (_, ids, __) {
                final saved = ids.contains(job.id);
                return OutlinedButton.icon(
                  onPressed: () {
                    SavedJobsStore.toggle(job.id);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(saved ? 'Đã bỏ lưu' : 'Đã lưu việc làm'),
                      duration: const Duration(seconds: 1),
                    ));
                  },
                  icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
                  label: Text(saved ? 'Đã lưu' : 'Lưu'),
                );
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  // TV3 sẽ nối sang Form ứng tuyển
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Chuyển sang màn Ứng tuyển (TV3)')));
                },
                child: const Text('Ứng tuyển ngay'),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _info(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          SizedBox(width: 80, child: Text(label)),
          Expanded(
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
        ]),
      );
}
