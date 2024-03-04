import 'package:flutter/foundation.dart' show immutable;

@immutable
class AttendanceStudent {
  final int attendanceId;
  final String matricNo;
  final int attendanceRecord;
  final String? staffId;
  final DateTime createdAt;

  const AttendanceStudent({
    required this.attendanceId,
    required this.matricNo,
    required this.attendanceRecord,
    this.staffId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        "attendanceId": attendanceId,
        "matricNo": matricNo,
        "attendanceRecord": attendanceRecord,
        "staffId": staffId,
        "createdAt": createdAt.toIso8601String(),
      };

  factory AttendanceStudent.fromJson(Map<String, dynamic> json) =>
      AttendanceStudent(
        attendanceId: json["attendanceId"],
        matricNo: json["matricNo"],
        attendanceRecord: json["attendanceRecord"],
        staffId: json["staffId"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  @override
  String toString() =>
      "AttendanceStudent(attendanceId: $attendanceId, matricNo: $matricNo, attendanceRecord: $attendanceRecord, staffId: $staffId, createdAt: $createdAt)";

  @override
  bool operator ==(covariant AttendanceStudent other) =>
      identical(other, this) ||
      (other.attendanceId == attendanceId &&
          other.matricNo == matricNo &&
          other.attendanceRecord == attendanceRecord &&
          other.staffId == staffId &&
          other.createdAt == createdAt &&
          other.runtimeType == runtimeType);

  @override
  int get hashCode => Object.hash(
        attendanceId,
        matricNo,
        attendanceRecord,
        staffId,
        createdAt,
        runtimeType,
      );
}
