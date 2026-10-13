import 'package:flutter/material.dart';
import '../models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onDelete;
  final VoidCallback? onViewApplicants;
  final bool showMenu;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
    this.onEdit,
    this.onToggleStatus,
    this.onDelete,
    this.onViewApplicants,
    this.showMenu = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 8),
              _buildCompanyAndLocation(),
              const SizedBox(height: 10),
              _buildAttributesChips(),
              const Divider(height: 20),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            job.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (showMenu) _buildActionMenu(context),
      ],
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    final isOpen = job.status == JobStatus.open;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
      padding: EdgeInsets.zero,
      onSelected: (value) {
        if (value == 'applicants') onViewApplicants?.call();
        if (value == 'edit') onEdit?.call();
        if (value == 'toggle') onToggleStatus?.call();
        if (value == 'delete') onDelete?.call();
      },
      itemBuilder: (context) => [
        if (onViewApplicants != null)
          const PopupMenuItem(
            value: 'applicants',
            child: Row(
              children: [
                Icon(Icons.people, size: 18, color: Colors.blue),
                SizedBox(width: 8),
                Text('Xem hồ sơ ứng viên'),
              ],
            ),
          ),
        if (onEdit != null)
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 18, color: Colors.blue),
                SizedBox(width: 8),
                Text('Chỉnh sửa tin'),
              ],
            ),
          ),
        if (onToggleStatus != null)
          PopupMenuItem(
            value: 'toggle',
            child: Row(
              children: [
                Icon(
                  isOpen ? Icons.lock : Icons.lock_open,
                  size: 18,
                  color: Colors.orange,
                ),
                SizedBox(width: 8),
                Text(isOpen ? 'Đóng tin' : 'Mở lại tin'),
              ],
            ),
          ),
        if (onDelete != null)
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 18, color: Colors.red),
                SizedBox(width: 8),
                Text('Xóa tin', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCompanyAndLocation() {
    return Row(
      children: [
        const Icon(Icons.business, size: 16, color: Colors.blue),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            job.companyName,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.location_on, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          job.location,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildAttributesChips() {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        _buildTag(job.level, Icons.workspace_premium),
        _buildTag(job.jobType, Icons.schedule),
        _buildTag(job.industry, Icons.category),
      ],
    );
  }

  Widget _buildTag(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final isOpen = job.status == JobStatus.open;
    final isExpired = job.isExpired;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.attach_money, size: 16, color: Colors.green),
                Text(
                  job.salaryDisplay,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: onViewApplicants,
              borderRadius: BorderRadius.circular(4),
              child: Row(
                children: [
                  const Icon(Icons.people, size: 15, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    '${job.applicantCount} hồ sơ',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• Hạn: ${job.deadlineDisplay}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isExpired)
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red),
                ),
                child: const Text(
                  'Hết hạn',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isOpen ? Colors.green.shade50 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isOpen ? Colors.green : Colors.grey,
                ),
              ),
              child: Text(
                isOpen ? 'Đang mở' : 'Đã đóng',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isOpen ? Colors.green.shade800 : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
