import 'package:flutter/material.dart';
import '../../models/job.dart';
import '../../models/job_filter.dart';
import '../../models/mock_jobs.dart';
import '../../widgets/job_card.dart';
import 'filter_sheet.dart';
import 'job_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final String initialQuery;
  final JobFilter? initialFilter;
  const SearchScreen({super.key, this.initialQuery = '', this.initialFilter});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _ctrl;
  late JobFilter _filter;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialQuery);
    _filter = widget.initialFilter ?? JobFilter();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<Job> get _results {
    final q = _ctrl.text.trim().toLowerCase();
    return mockJobs.where((j) {
      final okKeyword = q.isEmpty ||
          j.title.toLowerCase().contains(q) ||
          j.company.toLowerCase().contains(q) ||
          j.industry.toLowerCase().contains(q);
      return okKeyword && _filter.matches(j);
    }).toList();
  }

  Future<void> _openFilter() async {
    final result = await showFilterSheet(context, _filter);
    if (result != null) setState(() => _filter = result);
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          autofocus: widget.initialQuery.isEmpty && widget.initialFilter == null,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Tìm việc, công ty, ngành...',
            border: InputBorder.none,
          ),
          onChanged: (_) => setState(() {}),
          // 15/10: ở đây gọi SQLite lưu search_history
        ),
        actions: [
          if (_ctrl.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _ctrl.clear()),
            ),
          IconButton(
            tooltip: 'Bộ lọc',
            onPressed: _openFilter,
            icon: Badge(
              isLabelVisible: _filter.activeCount > 0,
              label: Text('${_filter.activeCount}'),
              child: const Icon(Icons.tune),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${results.length} việc làm phù hợp',
                  style: TextStyle(color: Theme.of(context).colorScheme.outline)),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? const Center(child: Text('Không tìm thấy việc làm phù hợp'))
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (_, i) => JobCard(
                      job: results[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => JobDetailScreen(job: results[i])),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
