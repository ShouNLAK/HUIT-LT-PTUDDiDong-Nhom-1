import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/candidate_model.dart';
import '../../TV4/services/job_file_service.dart';

class CandidateFileService {
  static final CandidateFileService _instance = CandidateFileService._internal();
  factory CandidateFileService() => _instance;
  CandidateFileService._internal();

  static const String _fileName = 'applicants.txt';

  Future<File> _getFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return File('${directory.path}/$_fileName');
    } catch (e) {
      throw Exception('Không thể truy cập thư mục lưu trữ: $e');
    }
  }

  Future<void> _writeApplicantsToFile(List<ApplicantModel> applicants) async {
    try {
      final file = await _getFile();
      final lines = applicants.map((a) => a.toJson()).join('\n');
      await file.writeAsString(lines, flush: true);
    } catch (e) {
      throw Exception('Lỗi khi ghi dữ liệu hồ sơ: $e');
    }
  }

  Future<List<ApplicantModel>> getAllApplicants() async {
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
      final List<ApplicantModel> applicants = [];

      for (var line in lines) {
        final trimmed = line.trim();
        if (trimmed.isNotEmpty) {
          try {
            final app = ApplicantModel.fromJson(trimmed);
            applicants.add(app);
          } catch (_) {}
        }
      }

      return applicants;
    } catch (e) {
      throw Exception('Lỗi khi đọc danh sách hồ sơ: $e');
    }
  }

  Future<void> updateApplicant(ApplicantModel updated) async {
    try {
      final applicants = await getAllApplicants();
      final index = applicants.indexWhere((a) => a.id == updated.id);
      if (index != -1) {
        applicants[index] = updated;
        await _writeApplicantsToFile(applicants);
      }
    } catch (e) {
      throw Exception('Lỗi khi cập nhật hồ sơ: $e');
    }
  }

  Future<void> deleteApplicant(String id) async {
    try {
      final applicants = await getAllApplicants();
      final index = applicants.indexWhere((a) => a.id == id);
      if (index != -1) {
        final removed = applicants.removeAt(index);
        await _writeApplicantsToFile(applicants);
        await JobFileService().decrementApplicantCount(removed.appliedPosition);
      }
    } catch (e) {
      throw Exception('Lỗi khi xóa hồ sơ: $e');
    }
  }

  Future<List<ApplicantModel>> seedSampleData() async {
    try {
      final sampleApplicants = [
        ApplicantModel(id: 'app_1', name: 'Nguyễn Văn An', appliedPosition: 'Lập trình viên Flutter (Mobile App)', appliedDate: '12/10/2026', status: ApplicationStatus.pending, cvFileName: 'NguyenVanAn_Flutter.pdf'),
        ApplicantModel(id: 'app_2', name: 'Trần Thị Bích', appliedPosition: 'Lập trình viên Flutter (Mobile App)', appliedDate: '11/10/2026', status: ApplicationStatus.interview, cvFileName: 'TranThiBich_CV.pdf'),
        ApplicantModel(id: 'app_3', name: 'Lê Hoàng Cường', appliedPosition: 'Lập trình viên Flutter (Mobile App)', appliedDate: '10/10/2026', status: ApplicationStatus.accepted, cvFileName: 'LeHoangCuong_CV.pdf'),
        ApplicantModel(id: 'app_4', name: 'Phạm Minh Dũng', appliedPosition: 'Lập trình viên Flutter (Mobile App)', appliedDate: '09/10/2026', status: ApplicationStatus.pending, cvFileName: 'PhamMinhDung_Resume.pdf'),
        ApplicantModel(id: 'app_5', name: 'Hoàng Thị Giang', appliedPosition: 'Lập trình viên Flutter (Mobile App)', appliedDate: '08/10/2026', status: ApplicationStatus.rejected, cvFileName: 'HoangThiGiang_CV.pdf'),

        ApplicantModel(id: 'app_6', name: 'Vũ Quốc Huy', appliedPosition: 'Chuyên viên Phân tích Dữ liệu (Data Analyst)', appliedDate: '12/10/2026', status: ApplicationStatus.pending, cvFileName: 'VuQuocHuy_DA.pdf'),
        ApplicantModel(id: 'app_7', name: 'Đỗ Hải Nam', appliedPosition: 'Chuyên viên Phân tích Dữ liệu (Data Analyst)', appliedDate: '11/10/2026', status: ApplicationStatus.interview, cvFileName: 'DoHaiNam_CV.pdf'),
        ApplicantModel(id: 'app_8', name: 'Bùi Phương Linh', appliedPosition: 'Chuyên viên Phân tích Dữ liệu (Data Analyst)', appliedDate: '10/10/2026', status: ApplicationStatus.pending, cvFileName: 'BuiPhuongLinh_CV.pdf'),
        ApplicantModel(id: 'app_9', name: 'Ngô Thanh Tùng', appliedPosition: 'Chuyên viên Phân tích Dữ liệu (Data Analyst)', appliedDate: '09/10/2026', status: ApplicationStatus.accepted, cvFileName: 'NgoThanhTung_Resume.pdf'),
        ApplicantModel(id: 'app_10', name: 'Dương Thị Mai', appliedPosition: 'Chuyên viên Phân tích Dữ liệu (Data Analyst)', appliedDate: '08/10/2026', status: ApplicationStatus.pending, cvFileName: 'DuongThiMai_CV.pdf'),
        ApplicantModel(id: 'app_11', name: 'Lý Kiến Quốc', appliedPosition: 'Chuyên viên Phân tích Dữ liệu (Data Analyst)', appliedDate: '07/10/2026', status: ApplicationStatus.interview, cvFileName: 'LyKienQuoc_CV.pdf'),
        ApplicantModel(id: 'app_12', name: 'Trịnh Bảo Trâm', appliedPosition: 'Chuyên viên Phân tích Dữ liệu (Data Analyst)', appliedDate: '06/10/2026', status: ApplicationStatus.rejected, cvFileName: 'TrinhBaoTram_CV.pdf'),
        ApplicantModel(id: 'app_13', name: 'Đặng Tuấn Anh', appliedPosition: 'Chuyên viên Phân tích Dữ liệu (Data Analyst)', appliedDate: '05/10/2026', status: ApplicationStatus.pending, cvFileName: 'DangTuanAnh_CV.pdf'),

        ApplicantModel(id: 'app_14', name: 'Phan Diệu Hoa', appliedPosition: 'Thực tập sinh Thiết kế UI/UX Product', appliedDate: '12/10/2026', status: ApplicationStatus.pending, cvFileName: 'PhanDieuHoa_Portfolio.pdf'),
        ApplicantModel(id: 'app_15', name: 'Võ Minh Khôi', appliedPosition: 'Thực tập sinh Thiết kế UI/UX Product', appliedDate: '11/10/2026', status: ApplicationStatus.interview, cvFileName: 'VoMinhKhoi_UIUX.pdf'),
        ApplicantModel(id: 'app_16', name: 'Hồ Quỳnh Nga', appliedPosition: 'Thực tập sinh Thiết kế UI/UX Product', appliedDate: '11/10/2026', status: ApplicationStatus.accepted, cvFileName: 'HoQuynhNga_CV.pdf'),
        ApplicantModel(id: 'app_17', name: 'Lương Thế Phong', appliedPosition: 'Thực tập sinh Thiết kế UI/UX Product', appliedDate: '10/10/2026', status: ApplicationStatus.pending, cvFileName: 'LuongThePhong_Portfolio.pdf'),
        ApplicantModel(id: 'app_18', name: 'Mai Ngọc Sơn', appliedPosition: 'Thực tập sinh Thiết kế UI/UX Product', appliedDate: '09/10/2026', status: ApplicationStatus.interview, cvFileName: 'MaiNgocSon_CV.pdf'),
        ApplicantModel(id: 'app_19', name: 'Tạ Thùy Trang', appliedPosition: 'Thực tập sinh Thiết kế UI/UX Product', appliedDate: '08/10/2026', status: ApplicationStatus.rejected, cvFileName: 'TaThuyTrang_Portfolio.pdf'),
        ApplicantModel(id: 'app_20', name: 'Cao Văn Vũ', appliedPosition: 'Thực tập sinh Thiết kế UI/UX Product', appliedDate: '07/10/2026', status: ApplicationStatus.pending, cvFileName: 'CaoVanVu_CV.pdf'),
        ApplicantModel(id: 'app_21', name: 'Trần Gia Hân', appliedPosition: 'Thực tập sinh Thiết kế UI/UX Product', appliedDate: '06/10/2026', status: ApplicationStatus.interview, cvFileName: 'TranGiaHan_Portfolio.pdf'),
        ApplicantModel(id: 'app_22', name: 'Lê Thanh Bình', appliedPosition: 'Thực tập sinh Thiết kế UI/UX Product', appliedDate: '05/10/2026', status: ApplicationStatus.pending, cvFileName: 'LeThanhBinh_CV.pdf'),
        ApplicantModel(id: 'app_23', name: 'Nguyễn Thảo Chi', appliedPosition: 'Thực tập sinh Thiết kế UI/UX Product', appliedDate: '04/10/2026', status: ApplicationStatus.accepted, cvFileName: 'NguyenThaoChi_Portfolio.pdf'),
        ApplicantModel(id: 'app_24', name: 'Phạm Đức Duy', appliedPosition: 'Thực tập sinh Thiết kế UI/UX Product', appliedDate: '03/10/2026', status: ApplicationStatus.pending, cvFileName: 'PhamDucDuy_CV.pdf'),
        ApplicantModel(id: 'app_25', name: 'Hoàng Yến Nhi', appliedPosition: 'Thực tập sinh Thiết kế UI/UX Product', appliedDate: '02/10/2026', status: ApplicationStatus.interview, cvFileName: 'HoangYenNhi_Portfolio.pdf'),

        ApplicantModel(id: 'app_26', name: 'Đoàn Nhật Quang', appliedPosition: 'Trưởng nhóm Marketing Kỹ thuật số (Digital Lead)', appliedDate: '12/10/2026', status: ApplicationStatus.pending, cvFileName: 'DoanNhatQuang_Marketing.pdf'),
        ApplicantModel(id: 'app_27', name: 'Chu Bảo Thư', appliedPosition: 'Trưởng nhóm Marketing Kỹ thuật số (Digital Lead)', appliedDate: '10/10/2026', status: ApplicationStatus.interview, cvFileName: 'ChuBaoThu_CV.pdf'),
        ApplicantModel(id: 'app_28', name: 'Vũ Đăng Khoa', appliedPosition: 'Trưởng nhóm Marketing Kỹ thuật số (Digital Lead)', appliedDate: '08/10/2026', status: ApplicationStatus.accepted, cvFileName: 'VuDangKhoa_Resume.pdf'),

        ApplicantModel(id: 'app_29', name: 'Lâm Hải Đăng', appliedPosition: 'Lập trình viên Backend Java (Spring Boot)', appliedDate: '12/10/2026', status: ApplicationStatus.pending, cvFileName: 'LamHaiDang_Java.pdf'),
        ApplicantModel(id: 'app_30', name: 'Dương Khánh Linh', appliedPosition: 'Lập trình viên Backend Java (Spring Boot)', appliedDate: '11/10/2026', status: ApplicationStatus.interview, cvFileName: 'DuongKhanhLinh_CV.pdf'),
        ApplicantModel(id: 'app_31', name: 'Phan Trí Dũng', appliedPosition: 'Lập trình viên Backend Java (Spring Boot)', appliedDate: '09/10/2026', status: ApplicationStatus.pending, cvFileName: 'PhanTriDung_Resume.pdf'),
        ApplicantModel(id: 'app_32', name: 'Hà Kim Oanh', appliedPosition: 'Lập trình viên Backend Java (Spring Boot)', appliedDate: '08/10/2026', status: ApplicationStatus.accepted, cvFileName: 'HaKimOanh_CV.pdf'),
        ApplicantModel(id: 'app_33', name: 'Nguyễn Tấn Phát', appliedPosition: 'Lập trình viên Backend Java (Spring Boot)', appliedDate: '06/10/2026', status: ApplicationStatus.rejected, cvFileName: 'NguyenTanPhat_CV.pdf'),
        ApplicantModel(id: 'app_34', name: 'Bạch Tuyết Mai', appliedPosition: 'Lập trình viên Backend Java (Spring Boot)', appliedDate: '04/10/2026', status: ApplicationStatus.interview, cvFileName: 'BachTuyetMai_Java.pdf'),
      ];

      await _writeApplicantsToFile(sampleApplicants);
      return sampleApplicants;
    } catch (e) {
      throw Exception('Lỗi khi khởi tạo danh sách hồ sơ mẫu: $e');
    }
  }
}
