// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  final int id;
  final String postId;
  final String createdBy;
  final DateTime createdOn;
  final String comment;
  CommentModel({
    required this.id,
    required this.postId,
    required this.createdBy,
    required this.createdOn,
    required this.comment,
  });

  CommentModel copyWith({
    int? id,
    String? postId,
    String? createdBy,
    DateTime? createdOn,
    String? comment,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      createdBy: createdBy ?? this.createdBy,
      createdOn: createdOn ?? this.createdOn,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'post_id': postId,
      'created_by': createdBy,
      'created_on': createdOn.millisecondsSinceEpoch,
      'comment': comment,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as int,
      postId: map['post_id'] as String,
      createdBy: map['created_by'] as String,
      createdOn: map['created_on'] is String
          ? DateTime.parse(map['created_on'] as String)
          : DateTime.fromMillisecondsSinceEpoch(map['created_on'] as int),
      comment: map['comment'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(id: $id, postId: $postId, created_by: $createdBy, created_on: $createdOn, comment: $comment)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.postId == postId &&
        other.createdBy == createdBy &&
        other.createdOn == createdOn &&
        other.comment == comment;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postId.hashCode ^
        createdBy.hashCode ^
        createdOn.hashCode ^
        comment.hashCode;
  }
}
