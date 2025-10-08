import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime? createdAt;

  // Additional fields from profile API
  final String? phone;
  final List<Course>? enrolledCourses;
  final String? address;
  final String? fbLink;
  final String? fbName;
  final String? hsc;
  final String? institution;
  final String? parent;
  final String? roll;
  final String? branch;
  final bool? offline;

  const User({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.createdAt,
    this.phone,
    this.enrolledCourses,
    this.address,
    this.fbLink,
    this.fbName,
    this.hsc,
    this.institution,
    this.parent,
    this.roll,
    this.branch,
    this.offline,
  });

  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
    String? phone,
    List<Course>? enrolledCourses,
    String? address,
    String? fbLink,
    String? fbName,
    String? hsc,
    String? institution,
    String? parent,
    String? roll,
    String? branch,
    bool? offline,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      phone: phone ?? this.phone,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      address: address ?? this.address,
      fbLink: fbLink ?? this.fbLink,
      fbName: fbName ?? this.fbName,
      hsc: hsc ?? this.hsc,
      institution: institution ?? this.institution,
      parent: parent ?? this.parent,
      roll: roll ?? this.roll,
      branch: branch ?? this.branch,
      offline: offline ?? this.offline,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoUrl,
        createdAt,
        phone,
        enrolledCourses,
        address,
        fbLink,
        fbName,
        hsc,
        institution,
        parent,
        roll,
        branch,
        offline,
      ];
}

class Course extends Equatable {
  final String course;
  final String code;
  final String branchCode;
  final String branch;
  final String batchCode;
  final String batch;
  final String date; 
  final String access;

  const Course({
    required this.course,
    required this.code,
    required this.branchCode,
    required this.branch,
    required this.batchCode,
    required this.batch,
    required this.date,
    required this.access,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      course: json['course'] ?? '',
      code: json['code'] ?? '',
      branchCode: json['branchCode'] ?? '',
      branch: json['branch'] ?? '',
      batchCode: json['batchCode'] ?? '',
      batch: json['batch'] ?? '',
      date: json['date'] ?? '',
      access: json['access'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course': course,
      'code': code,
      'branchCode': branchCode,
      'branch': branch,
      'batchCode': batchCode,
      'batch': batch,
      'date': date,
      'access': access,
    };
  }

  @override
  List<Object?> get props => [
        course,
        code,
        branchCode,
        branch,
        batchCode,
        batch,
        date,
        access,
      ];
}
