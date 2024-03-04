import 'package:flutter/foundation.dart' show immutable;

@immutable
class Attendance {
  final int id;
  final int activityId;
  final String? staffId;
  final DateTime createdAt;

  const Attendance({
    required this.id,
    required this.activityId,
    this.staffId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'activityId': activityId,
        'staffId': staffId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: json['id'],
        activityId: json['activityId'],
        staffId: json['staffId'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  @override
  String toString() =>
      'Attendance(id: $id, activityId: $activityId, staffId: $staffId, createdAt: $createdAt)';

  @override
  bool operator ==(covariant Attendance other) => (other.id == id &&
      other.activityId == activityId &&
      other.staffId == staffId &&
      other.createdAt == createdAt);

  @override
  int get hashCode => Object.hashAll([
        id,
        activityId,
        staffId,
        createdAt,
      ]);
}
