import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      createdAt: user.createdAt,
    );
  }
}
