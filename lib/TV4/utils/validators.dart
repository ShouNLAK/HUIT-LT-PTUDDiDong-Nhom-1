class FormValidators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tiêu đề công việc';
    }
    if (value.trim().length < 10) {
      return 'Tiêu đề công việc phải có ít nhất 10 ký tự';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập mô tả công việc';
    }
    if (value.trim().length < 30) {
      return 'Mô tả công việc phải có ít nhất 30 ký tự (hiện có: ${value.trim().length})';
    }
    return null;
  }

  static String? validateRequirements(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập yêu cầu công việc';
    }
    if (value.trim().length < 10) {
      return 'Yêu cầu công việc phải có ít nhất 10 ký tự';
    }
    return null;
  }

  static String? validateSalary(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    final number = int.tryParse(value.trim());
    if (number == null) {
      return '$fieldName phải là số nguyên hợp lệ';
    }
    if (number <= 0) {
      return '$fieldName phải lớn hơn 0';
    }
    return null;
  }

  static String? validateSalaryRange(String? minStr, String? maxStr) {
    final min = int.tryParse(minStr?.trim() ?? '');
    final max = int.tryParse(maxStr?.trim() ?? '');

    if (min != null && max != null && min > max) {
      return 'Lương tối thiểu ($min triệu) không được lớn hơn lương tối đa ($max triệu)';
    }
    return null;
  }

  static String? validateDeadline(DateTime? deadline) {
    if (deadline == null) {
      return 'Vui lòng chọn hạn chót nộp hồ sơ';
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDay = DateTime(deadline.year, deadline.month, deadline.day);

    if (deadlineDay.isBefore(today)) {
      return 'Hạn nộp hồ sơ phải sau ngày hôm nay';
    }
    return null;
  }
}
