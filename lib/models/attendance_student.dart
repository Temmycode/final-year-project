import 'package:flutter/foundation.dart' show immutable;

@immutable
class AttendanceStudent {
  final int attendanceId;
  final String matricNo;
  final int attendanceRecord;
  final String createdAt;

  const AttendanceStudent({
    required this.attendanceId,
    required this.matricNo,
    required this.attendanceRecord,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        "attendanceId": attendanceId,
        "matricNo": matricNo,
        "attendanceRecord": attendanceRecord,
        "createdAt": createdAt,
      };

  factory AttendanceStudent.fromJson(Map<String, dynamic> json) =>
      AttendanceStudent(
        attendanceId: json["attendanceId"],
        matricNo: json["matricNo"],
        attendanceRecord: json["attendanceRecord"],
        createdAt: json["createdAt"],
      );

  @override
  String toString() =>
      "AttendanceStudent(attendanceId: $attendanceId, matricNo: $matricNo, attendanceRecord: $attendanceRecord, createdAt: $createdAt)";

  @override
  bool operator ==(covariant AttendanceStudent other) =>
      identical(other, this) ||
      (other.attendanceId == attendanceId &&
          other.matricNo == matricNo &&
          other.attendanceRecord == attendanceRecord &&
          other.createdAt == createdAt);

  @override
  int get hashCode => Object.hash(
        attendanceId,
        matricNo,
        attendanceRecord,
        createdAt,
      );
}
