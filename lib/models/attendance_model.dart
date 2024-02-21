import 'package:flutter/foundation.dart' show immutable;

@immutable
class Attendance {
  final int id;
  final int activityId;

  const Attendance({
    required this.id,
    required this.activityId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'activityId': activityId,
      };

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: json['id'],
        activityId: json['activityId'],
      );

  @override
  String toString() => 'Attendance(id: $id, activityId: $activityId)';

  @override
  bool operator ==(covariant Attendance other) =>
      (other.id == id && other.activityId == activityId);

  @override
  int get hashCode => Object.hashAll([id, activityId]);
}
