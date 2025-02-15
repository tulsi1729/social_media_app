import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String id;
  final String? userName;
  final String? profileImage;
  final String? bio;
  final String token;

  UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.userName,
    required this.profileImage,
    required this.bio,
    required this.token,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? id,
    String? userName,
    String? profileImage,
    String? bio,
    String? token,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      userName: userName ?? this.userName,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'id': id,
      'user_name': userName,
      'profile_image': profileImage,
      'bio': bio,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      userName: map['user_name'] ?? '',
      profileImage: map['profile_image'] ?? '',
      bio: map['bio'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, id: $id,user_name: $userName,bio: $bio,profile_image: $profileImage, token: $token,)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.id == id &&
        other.userName == userName &&
        other.profileImage == profileImage &&
        other.bio == bio &&
        other.token == token;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        id.hashCode ^
        userName.hashCode ^
        profileImage.hashCode ^
        bio.hashCode ^
        token.hashCode;
  }
}
