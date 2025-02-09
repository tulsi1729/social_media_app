import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class FollowModel {
  final int id;
  final int followers;
  final int followings;
  FollowModel({
    required this.id,
    required this.followers,
    required this.followings,
  });

  FollowModel copyWith({
    int? id,
    int? followers,
    int? followings,
  }) {
    return FollowModel(
      id: id ?? this.id,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'followers_count': followers,
      'following_count': followings,
    };
  }

  factory FollowModel.fromMap(Map<String, dynamic> map) {
    return FollowModel(
      id: map['id'] as int,
      followers: map['followers_count'] ?? 0,
      followings: map['following_count'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory FollowModel.fromJson(String source) =>
      FollowModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FollowModel(id: $id, follower_count: $followers, following_count: $followings)';

  @override
  bool operator ==(covariant FollowModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.followers == followers &&
        other.followings == followings;
  }

  @override
  int get hashCode => id.hashCode ^ followers.hashCode ^ followings.hashCode;
}
