import 'package:equatable/equatable.dart';

class CourseSubject extends Equatable {
  final String id;
  final String? title;
  final String? courseSubjectImage;
  final DateTime createdAt;
  final SubjectInfo subject;
  final CourseInfo course;

  const CourseSubject({
    required this.id,
    this.title,
    this.courseSubjectImage,
    required this.createdAt,
    required this.subject,
    required this.course,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        courseSubjectImage,
        createdAt,
        subject,
        course,
      ];
}

class SubjectInfo extends Equatable {
  final String id;
  final String title;
  final String? subjectImage;
  final DateTime createdAt;

  const SubjectInfo({
    required this.id,
    required this.title,
    this.subjectImage,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, subjectImage, createdAt];
}

class CourseInfo extends Equatable {
  final String id;
  final String courseId;
  final String productId;
  final String productName;
  final String productFullName;
  final String? productImage;
  final String category;
  final String subCategory;
  final double currencyAmount;
  final String? parent;
  final int platinum;
  final bool markAsArchieve;
  final String? archieveCourseId;
  final String? permalink;
  final String? facebookGroup;
  final DateTime createdAt;

  const CourseInfo({
    required this.id,
    required this.courseId,
    required this.productId,
    required this.productName,
    required this.productFullName,
    this.productImage,
    required this.category,
    required this.subCategory,
    required this.currencyAmount,
    this.parent,
    required this.platinum,
    required this.markAsArchieve,
    this.archieveCourseId,
    this.permalink,
    this.facebookGroup,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        productId,
        productName,
        productFullName,
        productImage,
        category,
        subCategory,
        currencyAmount,
        parent,
        platinum,
        markAsArchieve,
        archieveCourseId,
        permalink,
        facebookGroup,
        createdAt,
      ];
}

class ArchievedCourse extends Equatable {
  final String id;
  final String courseId;
  final String productId;
  final String productName;
  final String productFullName;
  final String? productImage;
  final String category;
  final String subCategory;
  final bool markAsArchieve;
  final DateTime? createdAt;

  const ArchievedCourse({
    required this.id,
    required this.courseId,
    required this.productId,
    required this.productName,
    required this.productFullName,
    this.productImage,
    required this.category,
    required this.subCategory,
    required this.markAsArchieve,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        productId,
        productName,
        productFullName,
        productImage,
        category,
        subCategory,
        markAsArchieve,
        createdAt,
      ];
}