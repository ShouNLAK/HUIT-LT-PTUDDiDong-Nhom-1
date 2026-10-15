import 'job.dart';

class JobFilter {
  String? industry;
  String? location;
  String? level;
  String? jobType;
  int minSalary; // triệu VND

  JobFilter({
    this.industry,
    this.location,
    this.level,
    this.jobType,
    this.minSalary = 0,
  });

  JobFilter copy() => JobFilter(
        industry: industry,
        location: location,
        level: level,
        jobType: jobType,
        minSalary: minSalary,
      );

  int get activeCount => [industry, location, level, jobType]
          .where((e) => e != null)
          .length +
      (minSalary > 0 ? 1 : 0);

  bool matches(Job j) {
    if (industry != null && j.industry != industry) return false;
    if (location != null && j.location != location) return false;
    if (level != null && j.level != level) return false;
    if (jobType != null && j.jobType != jobType) return false;
    if (j.salaryMax < minSalary) return false;
    return true;
  }
}
