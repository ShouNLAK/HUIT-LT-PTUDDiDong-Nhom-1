import 'package:flutter/material.dart';
import '../../models/job.dart';
import '../../services/job_file_service.dart';
import '../../widgets/job_card.dart';
import 'job_detail_employer_screen.dart';
import 'job_form_screen.dart';
import '../../../TV5/screens/candidate_screen.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  final _fileService = JobFileService();
  final TextEditingController _searchController = TextEditingController();

  List<Job> _allJobs = [];
  bool _isLoading = true;
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoading = true);
    try {
      final jobs = await _fileService.getAllJobs();
      if (mounted) {
        setState(() {
          _allJobs = jobs;
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

  List<Job> _getFilteredJobs(int tabIndex) {
    return _allJobs.where((job) {
      final matchesSearch = _searchKeyword.isEmpty ||
          job.title.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
          job.companyName.toLowerCase().contains(_searchKeyword.toLowerCase());

      if (!matchesSearch) return false;

      if (tabIndex == 1) return job.status == JobStatus.open;
      if (tabIndex == 2) return job.status == JobStatus.closed;
      return true;
    }).toList();
  }

  Future<void> _handleToggleStatus(Job job) async {
    try {
      await _fileService.toggleStatus(job.id);
      await _loadJobs();
      if (!mounted) return;
      final newStatus = job.status == JobStatus.open ? 'đã đóng' : 'đang mở';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tin "${job.title}" hiện $newStatus')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<bool> _handleDeleteJob(Job job) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa tin tuyển dụng "${job.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _fileService.deleteJob(job.id);
        await _loadJobs();
        if (!mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa tin tuyển dụng thành công!')),
        );
        return true;
      } catch (e) {
        if (!mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa: $e'), backgroundColor: Colors.red),
        );
      }
    }
    return false;
  }

  Future<void> _navigateToEdit(Job job) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => JobFormScreen(job: job)),
    );
    if (result == true) {
      _loadJobs();
    }
  }

  Future<void> _navigateToDetail(Job job) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => JobDetailEmployerScreen(job: job)),
    );
    if (result == true) {
      _loadJobs();
    }
  }

  Future<void> _navigateToCreate() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const JobFormScreen()),
    );
    if (result == true) {
      _loadJobs();
    }
  }

  Future<void> _navigateToCandidates(Job job) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CandidateListScreen(jobTitle: job.title),
      ),
    );
    _loadJobs();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tin tuyển dụng của tôi'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tất cả'),
              Tab(text: 'Đang mở'),
              Tab(text: 'Đã đóng'),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      children: [
                        _buildJobList(0),
                        _buildJobList(1),
                        _buildJobList(2),
                      ],
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToCreate,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm theo tiêu đề tin...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchKeyword.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchKeyword = '');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchKeyword = value.trim();
          });
        },
      ),
    );
  }

  Widget _buildJobList(int tabIndex) {
    final filteredList = _getFilteredJobs(tabIndex);

    if (filteredList.isEmpty) {
      return _buildEmptyView(tabIndex);
    }

    return RefreshIndicator(
      onRefresh: _loadJobs,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 4, bottom: 80),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final job = filteredList[index];

          return Dismissible(
            key: Key(job.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            ),
            confirmDismiss: (direction) async {
              return await _handleDeleteJob(job);
            },
            child: JobCard(
              job: job,
              onTap: () => _navigateToDetail(job),
              onEdit: () => _navigateToEdit(job),
              onToggleStatus: () => _handleToggleStatus(job),
              onDelete: () => _handleDeleteJob(job),
              onViewApplicants: () => _navigateToCandidates(job),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyView(int tabIndex) {
    String message = 'Chưa có tin tuyển dụng nào';
    if (_searchKeyword.isNotEmpty) {
      message = 'Không tìm thấy tin phù hợp';
    } else if (tabIndex == 1) {
      message = 'Không có tin nào đang mở';
    } else if (tabIndex == 2) {
      message = 'Không có tin nào đã đóng';
    }

    return RefreshIndicator(
      onRefresh: _loadJobs,
      child: ListView(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.work_off, size: 64, color: Colors.grey),
                const SizedBox(height: 14),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
