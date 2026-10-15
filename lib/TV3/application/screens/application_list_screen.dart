import 'package:flutter/material.dart';

import '../models/application_model.dart';
import 'application_detail_screen.dart';
import 'application_form_screen.dart';

class ApplicationListScreen extends StatefulWidget {
  const ApplicationListScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationListScreen> createState() => _ApplicationListScreenState();
}

class _ApplicationListScreenState extends State<ApplicationListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0F172A),
          title: const Text(
            'Quản lý ứng tuyển',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(105),
            child: Column(
              children: [
                // Thanh tìm kiếm
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 6.0,
                  ),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Tìm theo vị trí, công ty...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF94A3B8),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Color(0xFF64748B),
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                // Thanh TabBar
                TabBar(
                  isScrollable: true,
                  indicatorColor: const Color(0xFF2563EB),
                  indicatorWeight: 3,
                  labelColor: const Color(0xFF2563EB),
                  unselectedLabelColor: const Color(0xFF64748B),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                  tabs: const [
                    Tab(text: 'Tất cả'),
                    Tab(text: 'Đã nộp'),
                    Tab(text: 'Phỏng vấn'),
                    Tab(text: 'Trúng tuyển'),
                    Tab(text: 'Từ chối'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(null),
            _buildList(ApplicationStatus.pending),
            _buildList(ApplicationStatus.interview),
            _buildList(ApplicationStatus.accepted),
            _buildList(ApplicationStatus.rejected),
          ],
        ),
      ),
    );
  }

  Widget _buildList(ApplicationStatus? filterStatus) {
    final list = mockApplications.where((app) {
      final matchesStatus = filterStatus == null || app.status == filterStatus;
      final matchesQuery =
          _searchQuery.isEmpty ||
          app.jobTitle.toLowerCase().contains(_searchQuery) ||
          app.companyName.toLowerCase().contains(_searchQuery);
      return matchesStatus && matchesQuery;
    }).toList();

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 48,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chưa có đơn ứng tuyển nào',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        // Đảm bảo lấy màu an toàn từ Extension
        final Color statusColor = item.status.color;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ApplicationDetailScreen(application: item),
                  ),
                );
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: item.companyLogo.isNotEmpty
                                ? Image.network(
                                    item.companyLogo,
                                    fit: BoxFit.cover,
                                    // Xử lý khi hình ảnh bị lỗi/không tải được
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildFallbackLogo(
                                        item.companyName,
                                      );
                                    },
                                    // Hiển thị vòng xoay tải ảnh
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return const Center(
                                            child: SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                  )
                                : _buildFallbackLogo(item.companyName),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.jobTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF0F172A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.companyName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.status.label,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.appliedDate,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

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
          fontSize: 18,
        ),
      ),
    ),
  );
}
