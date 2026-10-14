import 'dart:convert';

class Job {
  final String id;
  final String title;
  final String company;
  final int salaryMin; // đơn vị: triệu VND/tháng
  final int salaryMax;
  final String location;
  final String industry;
  final String level;
  final String jobType;
  final String description;
  final String requirements;
  final DateTime deadline;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.salaryMin,
    required this.salaryMax,
    required this.location,
    required this.industry,
    required this.level,
    required this.jobType,
    required this.description,
    required this.requirements,
    required this.deadline,
  });

  String get salaryText => '$salaryMin - $salaryMax triệu';

  String get deadlineText =>
      '${deadline.day.toString().padLeft(2, '0')}/${deadline.month.toString().padLeft(2, '0')}/${deadline.year}';

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'company': company,
        'salaryMin': salaryMin,
        'salaryMax': salaryMax,
        'location': location,
        'industry': industry,
        'level': level,
        'jobType': jobType,
        'description': description,
        'requirements': requirements,
        'deadline': deadline.toIso8601String(),
      };

  factory Job.fromMap(Map<String, dynamic> m) => Job(
        id: (m['id'] ?? '').toString(),
        title: (m['title'] ?? '').toString(),
        company: (m['company'] ?? m['companyName'] ?? '').toString(),
        salaryMin: (m['salaryMin'] as num?)?.toInt() ?? 0,
        salaryMax: (m['salaryMax'] as num?)?.toInt() ?? 0,
        location: (m['location'] ?? '').toString(),
        industry: (m['industry'] ?? '').toString(),
        level: (m['level'] ?? '').toString(),
        jobType: (m['jobType'] ?? '').toString(),
        description: (m['description'] ?? '').toString(),
        requirements: (m['requirements'] ?? '').toString(),
        deadline: m['deadline'] is int
            ? DateTime.fromMillisecondsSinceEpoch(m['deadline'] as int)
            : DateTime.tryParse((m['deadline'] ?? '').toString()) ??
                DateTime.now(),
      );

  String toJson() => jsonEncode(toMap());

  factory Job.fromJson(String source) =>
      Job.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
