// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoryModel {
  final String imageUrl;
  final DateTime createdAt;
  final String id;
  final String uid;
  final String views;
  StoryModel({
    required this.imageUrl,
    required this.createdAt,
    required this.id,
    required this.uid,
    required this.views,
  });

  StoryModel copyWith({
    String? imageUrl,
    DateTime? createdAt,
    String? id,
    String? uid,
    String? views,
  }) {
    return StoryModel(
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      views: views ?? this.views,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image_url': imageUrl,
      'created_at': createdAt.millisecondsSinceEpoch,
      'id': id,
      'uid': uid,
      'views': views,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      imageUrl: map['image_url'] ?? '',
      createdAt:
          DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      views: map['views']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryModel.fromJson(String source) =>
      StoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoryModel(image_url: $imageUrl, created_at: $createdAt, id: $id, uid: $uid, views: $views)';
  }

  @override
  bool operator ==(covariant StoryModel other) {
    if (identical(this, other)) return true;

    return other.imageUrl == imageUrl &&
        other.createdAt == createdAt &&
        other.id == id &&
        other.uid == uid &&
        other.views == views;
  }

  @override
  int get hashCode {
    return imageUrl.hashCode ^
        createdAt.hashCode ^
        id.hashCode ^
        uid.hashCode ^
        views.hashCode;
  }
}
