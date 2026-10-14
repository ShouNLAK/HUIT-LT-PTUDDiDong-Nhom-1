import 'package:flutter/material.dart';
import '../models/job.dart';
import '../services/saved_jobs_store.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;
  const JobCard({super.key, required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: cs.primaryContainer,
                child: Text(job.company[0],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: cs.onPrimaryContainer)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(job.company, style: TextStyle(color: cs.outline)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.payments_outlined, size: 16, color: cs.primary),
                      const SizedBox(width: 4),
                      Text(job.salaryText,
                          style: TextStyle(
                              color: cs.primary, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      Icon(Icons.place_outlined, size: 16, color: cs.outline),
                      const SizedBox(width: 2),
                      Text(job.location),
                    ]),
                    const SizedBox(height: 8),
                    Wrap(spacing: 6, children: [
                      _tag(job.level, context),
                      _tag(job.jobType, context),
                    ]),
                  ],
                ),
              ),
              ValueListenableBuilder<Set<String>>(
                valueListenable: SavedJobsStore.savedIds,
                builder: (_, ids, __) {
                  final saved = ids.contains(job.id);
                  return IconButton(
                    tooltip: saved ? 'Bỏ lưu' : 'Lưu việc làm',
                    icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border,
                        color: saved ? cs.primary : null),
                    onPressed: () => SavedJobsStore.toggle(job.id),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(String text, BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12)),
      );
}
