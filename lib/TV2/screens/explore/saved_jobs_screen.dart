import 'package:flutter/material.dart';
import '../../models/mock_jobs.dart';
import '../../services/saved_jobs_store.dart';
import '../../widgets/job_card.dart';
import 'job_detail_screen.dart';

class SavedJobsScreen extends StatelessWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Việc làm đã lưu',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: SavedJobsStore.savedIds,
        builder: (context, savedIds, _) {
          final savedJobList =
              mockJobs.where((j) => savedIds.contains(j.id)).toList();
          if (savedJobList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Chưa có việc làm nào được lưu',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: savedJobList.length,
            itemBuilder: (context, index) {
              final job = savedJobList[index];
              return JobCard(
                job: job,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
