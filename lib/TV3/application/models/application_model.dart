import 'dart:convert';

import 'package:flutter/material.dart';

// Enum đồng bộ hoàn toàn với TV5
enum ApplicationStatus {
  pending, // Đang chờ / Đã nộp
  interview, // Phỏng vấn
  accepted, // Trúng tuyển
  rejected, // Từ chối
}

// Extension cung cấp nhãn và màu sắc
extension ApplicationStatusExtension on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.pending:
        return 'Đã nộp';
      case ApplicationStatus.interview:
        return 'Mời phỏng vấn';
      case ApplicationStatus.accepted:
        return 'Trúng tuyển';
      case ApplicationStatus.rejected:
        return 'Bị từ chối';
    }
  }

  Color get color {
    switch (this) {
      case ApplicationStatus.pending:
        return const Color(0xFF2563EB); // Blue
      case ApplicationStatus.interview:
        return const Color(0xFFD97706); // Amber
      case ApplicationStatus.accepted:
        return const Color(0xFF16A34A); // Green
      case ApplicationStatus.rejected:
        return const Color(0xFFDC2626); // Red
    }
  }
}

class Application {
  final String id;
  final String jobTitle;
  final String companyName;
  final String companyLogo;
  final String salaryText;
  final String location;
  final String jobType;
  final String appliedDate;
  ApplicationStatus status;
  final String cvFileName;
  final String coverLetter;

  Application({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.companyLogo,
    this.salaryText = '',
    this.location = '',
    this.jobType = '',
    required this.appliedDate,
    required this.status,
    required this.cvFileName,
    required this.coverLetter,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'salaryText': salaryText,
      'location': location,
      'jobType': jobType,
      'appliedDate': appliedDate,
      'status': status.name,
      'cvFileName': cvFileName,
      'coverLetter': coverLetter,
    };
  }

  factory Application.fromMap(Map<String, dynamic> map) {
    return Application(
      id: map['id'] ?? '',
      jobTitle: map['jobTitle'] ?? map['appliedPosition'] ?? '',
      companyName: map['companyName'] ?? '',
      companyLogo: map['companyLogo'] ?? '',
      salaryText: map['salaryText'] ?? '',
      location: map['location'] ?? '',
      jobType: map['jobType'] ?? '',
      appliedDate: map['appliedDate'] ?? '',
      status: ApplicationStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => ApplicationStatus.pending,
      ),
      cvFileName: map['cvFileName'] ?? '',
      coverLetter: map['coverLetter'] ?? '',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Application.fromJson(String source) =>
      Application.fromMap(jsonDecode(source));
}

// Dữ liệu mẫu dùng chung
List<Application> mockApplications = [
  Application(
    id: 'APP001',
    jobTitle: 'Flutter Developer (Fresher)',
    companyName: 'FPT Software',
    companyLogo: 'https://tse3.mm.bing.net/th/id/OIP.-fRNPEOTGLfkp4frtIoPOwHaG-?r=0&pid=Api&h=220&P=0',
    salaryText: '8 - 10 triệu',
    location: 'Hà Nội',
    jobType: 'Full-time',
    appliedDate: '10/10/2026',
    status: ApplicationStatus.pending,
    cvFileName: 'CV_Flutter.pdf',
    coverLetter: 'Mong muốn cống hiến cho công ty.',
  ),
  Application(
    id: 'APP002',
    jobTitle: 'QA/QC Engineer (Junior)',
    companyName: 'VNG Corporation',
    companyLogo: 'https://tse3.mm.bing.net/th/id/OIP.qR7ENjAuEPYNN87tKUXQYwHaEO?r=0&pid=Api&h=220&P=0',
    salaryText: '10 - 15 triệu',
    location: 'TP. Hồ Chí Minh',
    jobType: 'Full-time',
    appliedDate: '08/10/2026',
    status: ApplicationStatus.interview,
    cvFileName: 'CV_QA.pdf',
    coverLetter: 'Tôi có kinh nghiệm viết testcase.',
  ),
  Application(
    id: 'APP003',
    jobTitle: 'Mobile App Developer',
    companyName: 'Tiki Vietnam',
    companyLogo: 'https://tse3.mm.bing.net/th/id/OIP.W16rtiiB_bn9uGQKKmhfkQHaHa?r=0&pid=Api&h=220&P=0',
    salaryText: '12 - 18 triệu',
    location: 'TP. Hồ Chí Minh',
    jobType: 'Full-time',
    appliedDate: '01/10/2026',
    status: ApplicationStatus.interview,
    cvFileName: 'CV_Mobile.pdf',
    coverLetter: 'Đã có kinh nghiệm thực hiện các dự án môn học về ứng dụng di động đa nền tảng.',
  ),
  Application(
    id: 'APP004',
    jobTitle: 'Kế toán',
    companyName: 'Tập đoàn Vingroup',
    companyLogo: 'https://tse1.mm.bing.net/th/id/OIP.iqb0sL0eWjd69P4P7E_VBgHaHa?r=0&pid=Api&h=220&P=0',
    salaryText: '10 - 15 triệu',
    location: 'Quảng Nam',
    jobType: 'Full-time',
    appliedDate: '12/10/2026',
    status: ApplicationStatus.pending,
    cvFileName: 'CV_KeToan.pdf',
    coverLetter: 'Tôi có chứng chỉ kế toán trưởng và kinh nghiệm quyết toán thuế, mong muốn cống hiến cho tập đoàn.',
  ),
  Application(
    id: 'APP005',
    jobTitle: 'Chuyên viên Digital Marketing',
    companyName: 'Công ty Unilever Việt Nam',
    companyLogo: 'https://tse1.mm.bing.net/th/id/OIP.fURGWgis6K6qPyDXZoBH7AHaHa?r=0&pid=Api&h=220&P=0',
    salaryText: '10 - 15 triệu',
    location: 'TP. Hồ Chí Minh',
    jobType: 'Full-time',
    appliedDate: '05/10/2026',
    status: ApplicationStatus.interview,
    cvFileName: 'CV_Marketing.pdf',
    coverLetter: 'Với kinh nghiệm chạy chiến dịch Ads và sáng tạo nội dung, tôi tin mình sẽ đáp ứng tốt yêu cầu công việc.',
  ),
];
