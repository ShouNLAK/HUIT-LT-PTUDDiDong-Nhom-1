import 'package:flutter/material.dart';
import '../../models/job.dart';
import '../../services/job_file_service.dart';
import '../../widgets/job_card.dart';
import '../../widgets/stat_card.dart';
import 'job_detail_employer_screen.dart';
import 'job_form_screen.dart';
import 'my_jobs_screen.dart';
import '../../../TV5/screens/candidate_screen.dart';

class EmployerDashboardScreen extends StatefulWidget {
  const EmployerDashboardScreen({super.key});

  @override
  State<EmployerDashboardScreen> createState() => _EmployerDashboardScreenState();
}

class _EmployerDashboardScreenState extends State<EmployerDashboardScreen> {
  final _fileService = JobFileService();
  List<Job> _jobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final jobs = await _fileService.getAllJobs();
      if (mounted) {
        setState(() {
          _jobs = jobs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải dữ liệu: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _navigateToCreateJob() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const JobFormScreen()),
    );
    if (result == true) {
      _loadDashboardData();
    }
  }

  Future<void> _navigateToJobDetail(Job job) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => JobDetailEmployerScreen(job: job)),
    );
    if (result == true) {
      _loadDashboardData();
    }
  }

  Future<void> _navigateToAllJobs() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyJobsScreen()),
    );
    _loadDashboardData();
  }

  Future<void> _navigateToCandidates([String jobTitle = 'Tất cả vị trí tuyển dụng']) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CandidateListScreen(jobTitle: jobTitle),
      ),
    );
    _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng điều khiển tuyển dụng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Danh sách tin',
            onPressed: _navigateToAllJobs,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới',
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: _jobs.isEmpty
                  ? _buildEmptyDashboard()
                  : ListView(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      children: [
                        _buildStatisticsSection(),
                        const SizedBox(height: 16),
                        _buildRecentJobsHeader(),
                        _buildRecentJobsList(),
                        const SizedBox(height: 70),
                      ],
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateJob,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    final totalJobs = _jobs.length;
    final openJobs = _jobs.where((j) => j.status == JobStatus.open).length;
    final totalApplicants = _jobs.fold<int>(
      0,
      (sum, job) => sum + job.applicantCount,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thống kê tổng quan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Tổng số tin',
                  value: '$totalJobs',
                  icon: Icons.work,
                  color: Colors.blue,
                  onTap: _navigateToAllJobs,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  title: 'Tin đang mở',
                  value: '$openJobs',
                  icon: Icons.check_circle,
                  color: Colors.green,
                  onTap: _navigateToAllJobs,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  title: 'Hồ sơ nhận',
                  value: '$totalApplicants',
                  icon: Icons.people,
                  color: Colors.orange,
                  onTap: () => _navigateToCandidates('Tất cả vị trí tuyển dụng'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentJobsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tin tuyển dụng gần đây',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: _navigateToAllJobs,
            child: const Row(
              children: [
                Text('Xem tất cả'),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentJobsList() {
    final recentJobs = _jobs.take(3).toList();

    return Column(
      children: recentJobs.map((job) {
        return JobCard(
          job: job,
          showMenu: true,
          onTap: () => _navigateToJobDetail(job),
          onViewApplicants: () => _navigateToCandidates(job.title),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyDashboard() {
    return ListView(
      children: [
        const SizedBox(height: 120),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.business_center, size: 72, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Chưa có tin tuyển dụng nào',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hãy đăng tin tuyển dụng đầu tiên của bạn!',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _navigateToCreateJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Đăng tin ngay'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
