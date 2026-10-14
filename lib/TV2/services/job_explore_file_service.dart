import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/job.dart';
import '../models/mock_jobs.dart';

class JobExploreFileService {
  static final JobExploreFileService _instance = JobExploreFileService._internal();
  factory JobExploreFileService() => _instance;
  JobExploreFileService._internal();

  static const String _fileName = 'explore_jobs.txt';

  Future<File> _getFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return File('${directory.path}/$_fileName');
    } catch (e) {
      throw Exception('Không thể truy cập thư mục lưu trữ tài liệu: $e');
    }
  }

  Future<void> _writeJobsToFile(List<Job> jobs) async {
    try {
      final file = await _getFile();
      final lines = jobs.map((job) => job.toJson()).join('\n');
      await file.writeAsString(lines, flush: true);
    } catch (e) {
      throw Exception('Lỗi khi ghi dữ liệu việc làm: $e');
    }
  }

  Future<List<Job>> getAllJobs() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        return await seedSampleData();
      }

      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        return await seedSampleData();
      }

      final lines = content.split('\n');
      final List<Job> jobs = [];

      for (var line in lines) {
        final trimmed = line.trim();
        if (trimmed.isNotEmpty) {
          try {
            final job = Job.fromJson(trimmed);
            jobs.add(job);
          } catch (_) {}
        }
      }

      if (jobs.isEmpty) {
        return await seedSampleData();
      }

      mockJobs.clear();
      mockJobs.addAll(jobs);
      return jobs;
    } catch (e) {
      throw Exception('Lỗi khi đọc danh sách việc làm: $e');
    }
  }

  Future<void> addJob(Job job) async {
    try {
      final jobs = await getAllJobs();
      jobs.insert(0, job);
      await _writeJobsToFile(jobs);
      mockJobs.clear();
      mockJobs.addAll(jobs);
    } catch (e) {
      throw Exception('Lỗi khi thêm việc làm: $e');
    }
  }

  Future<List<Job>> seedSampleData() async {
    final sampleJobs = [
      Job(
        id: 'j01',
        title: 'Flutter Developer',
        company: 'FPT Software',
        salaryMin: 15,
        salaryMax: 25,
        location: 'Hà Nội',
        industry: 'IT',
        level: 'Junior',
        jobType: 'Toàn thời gian',
        description: 'Phát triển ứng dụng di động đa nền tảng bằng Flutter cho khách hàng trong và ngoài nước.',
        requirements: '- Nắm vững Dart, Flutter\n- Biết dùng Git, REST API\n- Có kinh nghiệm Firebase là lợi thế',
        deadline: DateTime(2026, 11, 30),
      ),
      Job(
        id: 'j02',
        title: 'Backend Intern (Node.js)',
        company: 'VNG Corporation',
        salaryMin: 5,
        salaryMax: 8,
        location: 'TP.HCM',
        industry: 'IT',
        level: 'Intern',
        jobType: 'Thực tập',
        description: 'Hỗ trợ team xây dựng API cho hệ thống nội bộ, được mentor kèm cặp.',
        requirements: '- Biết JavaScript/Node.js cơ bản\n- Hiểu SQL\n- Chăm chỉ, ham học hỏi',
        deadline: DateTime(2026, 11, 15),
      ),
      Job(
        id: 'j03',
        title: 'Digital Marketing Executive',
        company: 'Vinamilk',
        salaryMin: 10,
        salaryMax: 16,
        location: 'TP.HCM',
        industry: 'Marketing',
        level: 'Junior',
        jobType: 'Toàn thời gian',
        description: 'Lên kế hoạch và triển khai chiến dịch quảng cáo trên Facebook, Google, TikTok.',
        requirements: '- Có kinh nghiệm chạy Ads\n- Kỹ năng viết nội dung\n- Biết phân tích số liệu',
        deadline: DateTime(2026, 12, 5),
      ),
      Job(
        id: 'j04',
        title: 'Kế toán tổng hợp',
        company: 'Công ty Hòa Phát',
        salaryMin: 12,
        salaryMax: 18,
        location: 'Hà Nội',
        industry: 'Kế toán',
        level: 'Senior',
        jobType: 'Toàn thời gian',
        description: 'Tổng hợp số liệu, lập báo cáo tài chính, làm việc với cơ quan thuế.',
        requirements: '- Tốt nghiệp Kế toán/Kiểm toán\n- Từ 3 năm kinh nghiệm\n- Thành thạo Excel, MISA',
        deadline: DateTime(2026, 11, 20),
      ),
      Job(
        id: 'j05',
        title: 'UI/UX Designer',
        company: 'Momo',
        salaryMin: 18,
        salaryMax: 30,
        location: 'TP.HCM',
        industry: 'Thiết kế',
        level: 'Senior',
        jobType: 'Toàn thời gian',
        description: 'Thiết kế trải nghiệm người dùng cho ứng dụng ví điện tử hàng triệu người dùng.',
        requirements: '- Thành thạo Figma\n- Có portfolio\n- Hiểu design system',
        deadline: DateTime(2026, 12, 10),
      ),
      Job(
        id: 'j06',
        title: 'Nhân viên bán hàng',
        company: 'Thế Giới Di Động',
        salaryMin: 7,
        salaryMax: 12,
        location: 'Đà Nẵng',
        industry: 'Bán hàng',
        level: 'Fresher',
        jobType: 'Bán thời gian',
        description: 'Tư vấn và bán điện thoại, phụ kiện tại cửa hàng.',
        requirements: '- Giao tiếp tốt\n- Nhiệt tình\n- Có thể làm theo ca',
        deadline: DateTime(2026, 11, 10),
      ),
      Job(
        id: 'j07',
        title: 'Gia sư Tiếng Anh online',
        company: 'Apollo English',
        salaryMin: 8,
        salaryMax: 14,
        location: 'Remote',
        industry: 'Giáo dục',
        level: 'Fresher',
        jobType: 'Freelance',
        description: 'Dạy tiếng Anh giao tiếp 1-1 qua Zoom, tự sắp xếp lịch.',
        requirements: '- IELTS 6.5 trở lên\n- Phát âm chuẩn\n- Có máy tính, mạng ổn định',
        deadline: DateTime(2026, 12, 20),
      ),
      Job(
        id: 'j08',
        title: 'Mobile Team Lead',
        company: 'Tiki',
        salaryMin: 40,
        salaryMax: 60,
        location: 'Hà Nội',
        industry: 'IT',
        level: 'Manager',
        jobType: 'Toàn thời gian',
        description: 'Dẫn dắt team 6 người phát triển app mua sắm, định hướng kiến trúc và quy trình.',
        requirements: '- 5+ năm kinh nghiệm mobile\n- Có kinh nghiệm quản lý\n- Hiểu CI/CD',
        deadline: DateTime(2026, 12, 31),
      ),
      Job(
        id: 'j09',
        title: 'Content Creator',
        company: 'Yan Entertainment',
        salaryMin: 9,
        salaryMax: 15,
        location: 'Remote',
        industry: 'Marketing',
        level: 'Junior',
        jobType: 'Freelance',
        description: 'Sản xuất nội dung video ngắn và bài viết cho các kênh mạng xã hội.',
        requirements: '- Biết dựng video (CapCut/Premiere)\n- Sáng tạo, bắt trend nhanh',
        deadline: DateTime(2026, 11, 25),
      ),
      Job(
        id: 'j10',
        title: 'Thực tập sinh Thiết kế đồ họa',
        company: 'Saigon Co.op',
        salaryMin: 4,
        salaryMax: 6,
        location: 'Đà Nẵng',
        industry: 'Thiết kế',
        level: 'Intern',
        jobType: 'Thực tập',
        description: 'Thiết kế banner, poster, ấn phẩm truyền thông cho chiến dịch của siêu thị.',
        requirements: '- Biết Photoshop/Illustrator\n- Thẩm mỹ tốt',
        deadline: DateTime(2026, 11, 18),
      ),
    ];

    try {
      await _writeJobsToFile(sampleJobs);
    } catch (_) {}

    mockJobs.clear();
    mockJobs.addAll(sampleJobs);
    return sampleJobs;
  }
}
