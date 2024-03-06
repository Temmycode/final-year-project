import 'package:flutter/foundation.dart' show immutable;

@immutable
class Activity {
  final int? id;
  final String title;
  final String type;
  final String imageUrl;
  final String? staffId;
  final DateTime createdAt;

  const Activity({
    this.id,
    required this.title,
    required this.type,
    required this.imageUrl,
    this.staffId,
    required this.createdAt,
  });

  Activity copyWith({
    String? title,
    String? type,
    String? imageUrl,
  }) =>
      Activity(
        title: title ?? this.title,
        type: type ?? this.type,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "type": type,
        "imageUrl": imageUrl,
        "staffId": staffId,
        "createdAt": createdAt.toIso8601String(),
      };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json["id"],
        title: json["title"],
        type: json["type"],
        imageUrl: json["imageUrl"],
        staffId: json["staffId"],
        createdAt: DateTime.parse(json["createdAt"]),
      );
  @override
  String toString() =>
      "Activity(id: $id, title: $title, type: $type, imageUrl: $imageUrl, staffId: $staffId, createdAt: $createdAt)";

  @override
  bool operator ==(covariant Activity other) => (other.id == id &&
      other.title == title &&
      other.type == type &&
      other.imageUrl == imageUrl &&
      other.staffId == staffId &&
      other.createdAt == createdAt &&
      other.runtimeType == runtimeType);

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        type,
        imageUrl,
        staffId,
        createdAt,
        runtimeType,
      ]);
}
