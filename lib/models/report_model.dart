import 'package:flutter_application_3/models/student_model.dart';

class Report {
  final Student student;
  final int attendanceRecord;

  const Report({
    required this.student,
    required this.attendanceRecord,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        student: json['student'],
        attendanceRecord: json['attendanceRecord'],
      );

  @override
  bool operator ==(covariant Report other) =>
      identical(this, other) ||
      (other.student == student &&
          other.attendanceRecord == attendanceRecord &&
          other.runtimeType == runtimeType);

  @override
  int get hashCode => Object.hashAll([
        student,
        attendanceRecord,
        runtimeType,
      ]);

  @override
  String toString() =>
      "Report(student: $student, attendanceRecord: $attendanceRecord)";
}
