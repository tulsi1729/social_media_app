import 'dart:convert';

class ReelModel {
  final String id;
  final String uid;
  final String videoUrl;
  final String caption;
  final DateTime createdOn;
  ReelModel({
    required this.id,
    required this.uid,
    required this.videoUrl,
    required this.caption,
    required this.createdOn,
  });

  ReelModel copyWith({
    String? id,
    String? uid,
    String? videoUrl,
    String? caption,
    DateTime? createdOn,
  }) {
    return ReelModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      videoUrl: videoUrl ?? this.videoUrl,
      caption: caption ?? this.caption,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'video_url': videoUrl,
      'caption': caption,
      'created_on': createdOn.millisecondsSinceEpoch,
    };
  }

  factory ReelModel.fromMap(Map<String, dynamic> map) {
    return ReelModel(
      id: map['id'] as String,
      uid: map['uid'] as String,
      videoUrl: map['video_url'] as String,
      caption: map['caption'] as String,
      createdOn: map['created_on'] is int
          ? DateTime.fromMillisecondsSinceEpoch(
              map['created_on'] as int) // ✅ Ensure int conversion
          : DateTime.parse(map['created_on'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelModel.fromJson(String source) =>
      ReelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReelModel(id: $id, uid: $uid, video_url: $videoUrl, caption: $caption, created_on: $createdOn)';
  }

  @override
  bool operator ==(covariant ReelModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        other.videoUrl == videoUrl &&
        other.caption == caption &&
        other.createdOn == createdOn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        videoUrl.hashCode ^
        caption.hashCode ^
        createdOn.hashCode;
  }
}
