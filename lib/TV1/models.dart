enum UserRole { candidate, employer }

extension UserRoleLabel on UserRole {
  String get label =>
      this == UserRole.candidate ? 'Ứng viên' : 'Nhà tuyển dụng';
}

class AppUser {
  final String id;
  final String email;
  final String name;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
}

class CandidateProfile {
  String phone;
  String position;
  String skills;
  String? cvFileName;

  CandidateProfile({
    this.phone = '',
    this.position = '',
    this.skills = '',
    this.cvFileName,
  });
}

const industries = [
  'Công nghệ thông tin',
  'Tài chính - Ngân hàng',
  'Bán lẻ',
  'Sản xuất',
  'Giáo dục',
  'Khác',
];

const companySizes = [
  'Dưới 50 nhân viên',
  '50 - 200 nhân viên',
  '200 - 1000 nhân viên',
  'Trên 1000 nhân viên',
];

class CompanyProfile {
  String name;
  String? industry;
  String? size;
  String address;
  String website;
  String description;

  CompanyProfile({
    this.name = '',
    this.industry,
    this.size,
    this.address = '',
    this.website = '',
    this.description = '',
  });
}
