// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostModel {
  final String id;
  final String caption;
  final String imageUrl;

  PostModel({
    required this.id,
    required this.caption,
    required this.imageUrl,
  });

  PostModel copyWith({
    String? id,
    String? caption,
    String? imageUrl,
  }) {
    return PostModel(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'caption': caption,
      'image_url': imageUrl,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? "",
      caption: map['caption'] ?? "",
      imageUrl: map['image_url'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PostModel(id: $id, caption: $caption, image_url: $imageUrl)';

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.caption == caption &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => id.hashCode ^ caption.hashCode ^ imageUrl.hashCode;
}
