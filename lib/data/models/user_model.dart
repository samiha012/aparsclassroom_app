import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.createdAt,
    super.phone,
    super.enrolledCourses,
    super.address,
    super.fbLink,
    super.fbName,
    super.hsc,
    super.institution,
    super.parent,
    super.roll,
    super.branch,
    super.offline,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json; // supports both wrapped and direct data
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['Email'] ?? '',
      displayName: data['Name'],
      photoUrl: data['photo'],
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'])
          : null,
      phone: data['Phone'],
      enrolledCourses: data['Courses'] != null
          ? (data['Courses'] as List)
              .map((e) => Course.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      address: data['Address'],
      fbLink: data['FbLink'],
      fbName: data['FbName'],
      hsc: data['HSC'],
      institution: data['Institution'],
      parent: data['Parent'],
      roll: data['roll'],
      branch: data['Branch'],
      offline: data['offline'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'Email': email,
      'Name': displayName,
      'photo': photoUrl,
      'created_at': createdAt?.toIso8601String(),
      'Phone': phone,
      'Courses': enrolledCourses?.map((course) => course.toJson()).toList(),
      'Address': address,
      'FbLink': fbLink,
      'FbName': fbName,
      'HSC': hsc,
      'Institution': institution,
      'Parent': parent,
      'roll': roll,
      'Branch': branch,
      'offline': offline,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      createdAt: user.createdAt,
      phone: user.phone,
      enrolledCourses: user.enrolledCourses,
      address: user.address,
      fbLink: user.fbLink,
      fbName: user.fbName,
      hsc: user.hsc,
      institution: user.institution,
      parent: user.parent,
      roll: user.roll,
      branch: user.branch,
      offline: user.offline,
    );
  }
}
