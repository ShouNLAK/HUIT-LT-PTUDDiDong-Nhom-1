import 'package:flutter/material.dart';
import '../../models/job_filter.dart';
import '../../models/mock_jobs.dart';

/// Mở bottom sheet bộ lọc. Trả về JobFilter mới khi bấm "Áp dụng".
Future<JobFilter?> showFilterSheet(BuildContext context, JobFilter current) {
  return showModalBottomSheet<JobFilter>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _FilterSheet(initial: current),
  );
}

class _FilterSheet extends StatefulWidget {
  final JobFilter initial;
  const _FilterSheet({required this.initial});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late JobFilter f;

  @override
  void initState() {
    super.initState();
    f = widget.initial.copy();
  }

  Widget _group(String title, List<String> options, String? selected,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: options
              .map((o) => ChoiceChip(
                    label: Text(o),
                    selected: selected == o,
                    onSelected: (s) => setState(() => onChanged(s ? o : null)),
                  ))
              .toList(),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            16, 0, 16, MediaQuery.of(context).viewInsets.bottom + 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Bộ lọc',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _group('Ngành', kIndustries, f.industry, (v) => f.industry = v),
              _group('Địa điểm', kLocations, f.location, (v) => f.location = v),
              _group('Cấp bậc', kLevels, f.level, (v) => f.level = v),
              _group('Hình thức', kJobTypes, f.jobType, (v) => f.jobType = v),
              Text(
                f.minSalary == 0
                    ? 'Mức lương tối thiểu: Tất cả'
                    : 'Mức lương tối thiểu: ${f.minSalary} triệu',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Slider(
                value: f.minSalary.toDouble(),
                min: 0,
                max: 50,
                divisions: 10,
                label: '${f.minSalary} triệu',
                onChanged: (v) => setState(() => f.minSalary = v.round()),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, JobFilter()),
                      child: const Text('Xóa lọc'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, f),
                      child: const Text('Áp dụng'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
