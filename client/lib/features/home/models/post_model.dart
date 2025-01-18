// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostModel {
  final String id;
  final String caption;
  final String postMediaUrl;
  PostModel({
    required this.id,
    required this.caption,
    required this.postMediaUrl,
  });

  PostModel copyWith({
    String? id,
    String? caption,
    String? postMediaUrl,
  }) {
    return PostModel(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      postMediaUrl: postMediaUrl ?? this.postMediaUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'caption': caption,
      'post_media': postMediaUrl,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? "",
      caption: map['caption'] ?? "",
      postMediaUrl: map['post_media'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PostModel(id: $id, caption: $caption, post_media: $postMediaUrl)';

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.caption == caption &&
        other.postMediaUrl == postMediaUrl;
  }

  @override
  int get hashCode => id.hashCode ^ caption.hashCode ^ postMediaUrl.hashCode;
}
