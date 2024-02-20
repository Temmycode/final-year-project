import 'package:flutter/foundation.dart' show immutable;

@immutable
class Activity {
  final int? id;
  final String title;
  final String type;
  final String imageUrl;

  const Activity({
    this.id,
    required this.title,
    required this.type,
    required this.imageUrl,
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "imageUrl": imageUrl,
      };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json["id"],
        title: json["title"],
        type: json["type"],
        imageUrl: json["imageUrl"],
      );
  @override
  String toString() =>
      "Activity(id: $id, title: $title, type: $type, imageUrl: $imageUrl)";

  @override
  bool operator ==(covariant Activity other) => (other.id == id &&
      other.title == title &&
      other.type == type &&
      other.imageUrl == imageUrl);

  @override
  int get hashCode => Object.hashAll([id, title, type, imageUrl]);
}
