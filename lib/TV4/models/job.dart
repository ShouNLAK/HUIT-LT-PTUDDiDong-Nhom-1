import 'dart:convert';
import 'package:intl/intl.dart';

enum JobStatus {
  open,
  closed,
}

class Job {
  final String id;
  final String title;
  final String companyName;
  final String location;
  final String industry;
  final String level;
  final String jobType;
  final int salaryMin;
  final int salaryMax;
  final String description;
  final String requirements;
  final DateTime deadline;
  final DateTime createdAt;
  final JobStatus status;
  final int applicantCount;

  Job({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.industry,
    required this.level,
    required this.jobType,
    required this.salaryMin,
    required this.salaryMax,
    required this.description,
    required this.requirements,
    required this.deadline,
    required this.createdAt,
    this.status = JobStatus.open,
    this.applicantCount = 0,
  });

  bool get isExpired {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDay = DateTime(deadline.year, deadline.month, deadline.day);
    return deadlineDay.isBefore(today);
  }

  String get salaryDisplay {
    if (salaryMin == salaryMax) {
      return '$salaryMin triệu VNĐ';
    }
    return '$salaryMin - $salaryMax triệu VNĐ';
  }

  String get deadlineDisplay {
    return DateFormat('dd/MM/yyyy').format(deadline);
  }

  String get createdAtDisplay {
    return DateFormat('dd/MM/yyyy').format(createdAt);
  }

  String get statusDisplay {
    return status == JobStatus.open ? 'Đang mở' : 'Đã đóng';
  }

  Job copyWith({
    String? id,
    String? title,
    String? companyName,
    String? location,
    String? industry,
    String? level,
    String? jobType,
    int? salaryMin,
    int? salaryMax,
    String? description,
    String? requirements,
    DateTime? deadline,
    DateTime? createdAt,
    JobStatus? status,
    int? applicantCount,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      companyName: companyName ?? this.companyName,
      location: location ?? this.location,
      industry: industry ?? this.industry,
      level: level ?? this.level,
      jobType: jobType ?? this.jobType,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      applicantCount: applicantCount ?? this.applicantCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'companyName': companyName,
      'location': location,
      'industry': industry,
      'level': level,
      'jobType': jobType,
      'salaryMin': salaryMin,
      'salaryMax': salaryMax,
      'description': description,
      'requirements': requirements,
      'deadline': deadline.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'applicantCount': applicantCount,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      companyName: map['companyName']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      industry: map['industry']?.toString() ?? '',
      level: map['level']?.toString() ?? 'Nhân viên',
      jobType: map['jobType']?.toString() ?? 'Toàn thời gian',
      salaryMin: (map['salaryMin'] as num?)?.toInt() ?? 0,
      salaryMax: (map['salaryMax'] as num?)?.toInt() ?? 0,
      description: map['description']?.toString() ?? '',
      requirements: map['requirements']?.toString() ?? '',
      deadline: map['deadline'] != null
          ? DateTime.tryParse(map['deadline'].toString()) ?? DateTime.now()
          : DateTime.now(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      status: map['status'] == JobStatus.closed.name
          ? JobStatus.closed
          : JobStatus.open,
      applicantCount: (map['applicantCount'] as num?)?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Job.fromJson(String source) => Job.fromMap(json.decode(source));
}
