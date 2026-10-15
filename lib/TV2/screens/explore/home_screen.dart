import 'package:flutter/material.dart';
import '../../models/job.dart';
import '../../models/job_filter.dart';
import '../../models/mock_jobs.dart';
import '../../services/job_explore_file_service.dart';
import '../../services/saved_jobs_store.dart';
import '../../widgets/job_card.dart';
import 'job_detail_screen.dart';
import 'saved_jobs_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Job> _jobs = mockJobs;

  @override
  void initState() {
    super.initState();
    SavedJobsStore.init();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      final list = await JobExploreFileService().getAllJobs();
      if (!mounted) return;
      setState(() {
        _jobs = list;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobConnect',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Việc đã lưu',
            icon: const Icon(Icons.bookmark_border),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SavedJobsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadJobs,
        child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SearchScreen()),
                        );
                        _loadJobs();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Row(children: [
                          Icon(Icons.search, color: cs.outline),
                          const SizedBox(width: 8),
                          Text('Tìm việc, công ty, ngành...',
                              style: TextStyle(color: cs.outline)),
                        ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: kIndustries.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => ActionChip(
                        label: Text(kIndustries[i]),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SearchScreen(
                                initialFilter:
                                    JobFilter(industry: kIndustries[i])),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 6),
                    child: Text('Việc làm mới nhất',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  if (_jobs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: Text('Chưa có việc làm nào')),
                    )
                  else
                    ..._jobs.map((job) => JobCard(
                          job: job,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => JobDetailScreen(job: job)),
                          ),
                        )),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}
