import 'dart:convert';
import 'package:flutter/material.dart';

enum ApplicationStatus {
  pending,
  interview,
  accepted,
  rejected,
}

extension ApplicationStatusExtension on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.pending:
        return 'Đang chờ';
      case ApplicationStatus.interview:
        return 'Phỏng vấn';
      case ApplicationStatus.accepted:
        return 'Trúng tuyển';
      case ApplicationStatus.rejected:
        return 'Từ chối';
    }
  }

  Color get color {
    switch (this) {
      case ApplicationStatus.pending:
        return Colors.orange;
      case ApplicationStatus.interview:
        return Colors.blue;
      case ApplicationStatus.accepted:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
    }
  }
}

class ApplicantModel {
  final String id;
  final String name;
  final String appliedPosition;
  final String appliedDate;
  ApplicationStatus status;
  String? cvFileName;

  ApplicantModel({
    required this.id,
    required this.name,
    required this.appliedPosition,
    required this.appliedDate,
    required this.status,
    this.cvFileName,
  });

  ApplicantModel copyWith({
    String? id,
    String? name,
    String? appliedPosition,
    String? appliedDate,
    ApplicationStatus? status,
    String? cvFileName,
  }) {
    return ApplicantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      appliedPosition: appliedPosition ?? this.appliedPosition,
      appliedDate: appliedDate ?? this.appliedDate,
      status: status ?? this.status,
      cvFileName: cvFileName ?? this.cvFileName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'appliedPosition': appliedPosition,
      'appliedDate': appliedDate,
      'status': status.name,
      'cvFileName': cvFileName,
    };
  }

  factory ApplicantModel.fromMap(Map<String, dynamic> map) {
    return ApplicantModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      appliedPosition: map['appliedPosition'] ?? '',
      appliedDate: map['appliedDate'] ?? '',
      status: ApplicationStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => ApplicationStatus.pending,
      ),
      cvFileName: map['cvFileName'],
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ApplicantModel.fromJson(String source) =>
      ApplicantModel.fromMap(jsonDecode(source));
}