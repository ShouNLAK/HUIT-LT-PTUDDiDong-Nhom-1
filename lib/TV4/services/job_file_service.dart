import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/job.dart';

class JobFileService {
  static final JobFileService _instance = JobFileService._internal();
  factory JobFileService() => _instance;
  JobFileService._internal();

  static const String _fileName = 'jobs.txt';

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
      throw Exception('Lỗi khi ghi dữ liệu vào file: $e');
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

      jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return jobs;
    } catch (e) {
      throw Exception('Lỗi khi đọc danh sách tin tuyển dụng: $e');
    }
  }

  Future<void> addJob(Job job) async {
    try {
      final jobs = await getAllJobs();
      jobs.insert(0, job);
      await _writeJobsToFile(jobs);
    } catch (e) {
      throw Exception('Lỗi khi thêm tin tuyển dụng mới: $e');
    }
  }

  Future<void> updateJob(Job updatedJob) async {
    try {
      final jobs = await getAllJobs();
      final index = jobs.indexWhere((j) => j.id == updatedJob.id);
      if (index != -1) {
        jobs[index] = updatedJob;
        await _writeJobsToFile(jobs);
      } else {
        throw Exception('Không tìm thấy tin tuyển dụng với mã: ${updatedJob.id}');
      }
    } catch (e) {
      throw Exception('Lỗi khi cập nhật tin tuyển dụng: $e');
    }
  }

  Future<void> deleteJob(String id) async {
    try {
      final jobs = await getAllJobs();
      final initialCount = jobs.length;
      jobs.removeWhere((j) => j.id == id);
      if (jobs.length == initialCount) {
        throw Exception('Không tìm thấy tin cần xóa');
      }
      await _writeJobsToFile(jobs);
    } catch (e) {
      throw Exception('Lỗi khi xóa tin tuyển dụng: $e');
    }
  }

  Future<void> decrementApplicantCount(String jobTitle) async {
    try {
      final jobs = await getAllJobs();
      final cleanTarget = jobTitle.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      int index = jobs.indexWhere((j) {
        final cleanJob = j.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
        return cleanJob == cleanTarget ||
            cleanJob.contains(cleanTarget) ||
            cleanTarget.contains(cleanJob);
      });
      if (index == -1) {
        index = jobs.indexWhere((j) => j.applicantCount > 0);
      }
      if (index != -1 && jobs[index].applicantCount > 0) {
        jobs[index] = jobs[index].copyWith(
          applicantCount: jobs[index].applicantCount - 1,
        );
        await _writeJobsToFile(jobs);
      }
    } catch (_) {}
  }

  Future<void> toggleStatus(String id) async {
    try {
      final jobs = await getAllJobs();
      final index = jobs.indexWhere((j) => j.id == id);
      if (index != -1) {
        final current = jobs[index];
        final newStatus = current.status == JobStatus.open
            ? JobStatus.closed
            : JobStatus.open;
        jobs[index] = current.copyWith(status: newStatus);
        await _writeJobsToFile(jobs);
      } else {
        throw Exception('Không tìm thấy tin cần đổi trạng thái');
      }
    } catch (e) {
      throw Exception('Lỗi khi chuyển đổi trạng thái tin: $e');
    }
  }

  Future<List<Job>> seedSampleData() async {
    try {
      final now = DateTime.now();
      final sampleJobs = [
        Job(
          id: '${now.millisecondsSinceEpoch - 1000}',
          title: 'Lập trình viên Flutter (Mobile App)',
          companyName: 'FPT Software',
          location: 'TP. Hồ Chí Minh',
          industry: 'Công nghệ thông tin',
          level: 'Nhân viên',
          jobType: 'Toàn thời gian',
          salaryMin: 15,
          salaryMax: 25,
          description:
              'Tham gia phát triển các ứng dụng di động đa nền tảng bằng Flutter cho thị trường trong nước và quốc tế. Phối hợp chặt chẽ với đội ngũ UI/UX và Backend để hoàn thiện tính năng.',
          requirements:
              'Có ít nhất 1 năm kinh nghiệm làm việc với Flutter/Dart. Thành thạo quản lý state, RESTful API và tối ưu giao diện Material Design.',
          deadline: now.add(const Duration(days: 15)),
          createdAt: now.subtract(const Duration(days: 2)),
          status: JobStatus.open,
          applicantCount: 5,
        ),
        Job(
          id: '${now.millisecondsSinceEpoch - 2000}',
          title: 'Chuyên viên Phân tích Dữ liệu (Data Analyst)',
          companyName: 'Ngân hàng Vietcombank',
          location: 'Hà Nội',
          industry: 'Tài chính / Ngân hàng',
          level: 'Nhân viên',
          jobType: 'Toàn thời gian',
          salaryMin: 18,
          salaryMax: 30,
          description:
              'Thu thập, xử lý và trực quan hóa dữ liệu kinh doanh tài chính. Xây dựng các báo cáo định kỳ và dashboard theo dõi hiệu suất hoạt động của các chi nhánh.',
          requirements:
              'Tốt nghiệp đại học chuyên ngành CNTT, Toán tin hoặc Kinh tế. Sử dụng thành thạo SQL, Python và công cụ Power BI / Tableau.',
          deadline: now.add(const Duration(days: 20)),
          createdAt: now.subtract(const Duration(days: 5)),
          status: JobStatus.open,
          applicantCount: 8,
        ),
        Job(
          id: '${now.millisecondsSinceEpoch - 3000}',
          title: 'Thực tập sinh Thiết kế UI/UX Product',
          companyName: 'VNG Corporation',
          location: 'TP. Hồ Chí Minh',
          industry: 'Thiết kế / Sáng tạo',
          level: 'Thực tập',
          jobType: 'Bán thời gian',
          salaryMin: 5,
          salaryMax: 8,
          description:
              'Hỗ trợ thiết kế giao diện wireframe, prototype và UI hoàn chỉnh cho các sản phẩm game và tiện ích số. Tham gia nghiên cứu trải nghiệm người dùng.',
          requirements:
              'Sinh viên năm 3-4 chuyên ngành liên quan. Sử dụng tốt Figma, Illustrator. Có tư duy thẩm mỹ hiện đại và tinh thần học hỏi cao.',
          deadline: now.add(const Duration(days: 10)),
          createdAt: now.subtract(const Duration(days: 1)),
          status: JobStatus.open,
          applicantCount: 12,
        ),
        Job(
          id: '${now.millisecondsSinceEpoch - 4000}',
          title: 'Trưởng nhóm Marketing Kỹ thuật số (Digital Lead)',
          companyName: 'Shopee Việt Nam',
          location: 'TP. Hồ Chí Minh',
          industry: 'Marketing / Truyền thông',
          level: 'Trưởng nhóm',
          jobType: 'Toàn thời gian',
          salaryMin: 25,
          salaryMax: 40,
          description:
              'Lập kế hoạch và triển khai các chiến dịch tiếp thị số đa kênh (Facebook, Google, TikTok). Quản lý ngân sách quảng cáo và điều phối đội nhóm sáng tạo nội dung.',
          requirements:
              'Tối thiểu 3 năm kinh nghiệm trong lĩnh vực Digital Marketing, có kỹ năng lãnh đạo đội nhóm và phân tích số liệu chuyển đổi (ROI/ROAS).',
          deadline: now.add(const Duration(days: 30)),
          createdAt: now.subtract(const Duration(days: 7)),
          status: JobStatus.open,
          applicantCount: 3,
        ),
        Job(
          id: '${now.millisecondsSinceEpoch - 5000}',
          title: 'Lập trình viên Backend Java (Spring Boot)',
          companyName: 'MoMo E-Wallet',
          location: 'Đà Nẵng',
          industry: 'Công nghệ thông tin',
          level: 'Nhân viên',
          jobType: 'Remote',
          salaryMin: 20,
          salaryMax: 35,
          description:
              'Thiết kế và xây dựng các dịch vụ vi mô (Microservices) xử lý giao dịch thanh toán tốc độ cao. Tối ưu hiệu năng cơ sở dữ liệu và bảo mật hệ thống.',
          requirements:
              'Nắm vững Java Core, Spring Boot, Hibernate, MySQL/PostgreSQL và hệ thống hàng đợi Kafka/RabbitMQ. Đã từng làm việc theo mô hình Microservices.',
          deadline: now.add(const Duration(days: 5)),
          createdAt: now.subtract(const Duration(days: 10)),
          status: JobStatus.closed,
          applicantCount: 6,
        ),
      ];

      await _writeJobsToFile(sampleJobs);
      return sampleJobs;
    } catch (e) {
      throw Exception('Lỗi khi khởi tạo dữ liệu mẫu: $e');
    }
  }
}
