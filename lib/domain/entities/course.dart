import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String courseId;
  final String productId;
  final String productName;
  final String productFullName;
  final String? productImage;
  final String category;
  final String subCategory;
  final double currencyAmount;
  final String? permalink;
  final String? facebookGroup;
  final String? parent;
  final int platinum;
  final bool markAsArchieve;
  final String? archieveCourseId;
  final String? superAdminId;
  final bool cycleAvailable;
  final DateTime? createdAt;
  final int studentCount;
  final bool isEnrolled;

  const Course({
    required this.id,
    required this.courseId,
    required this.productId,
    required this.productName,
    required this.productFullName,
    this.productImage,
    required this.category,
    required this.subCategory,
    required this.currencyAmount,
    this.permalink,
    this.facebookGroup,
    this.parent,
    required this.platinum,
    required this.markAsArchieve,
    this.archieveCourseId,
    this.superAdminId,
    required this.cycleAvailable,
    this.createdAt,
    required this.studentCount,
    required this.isEnrolled,
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
        permalink,
        facebookGroup,
        parent,
        platinum,
        markAsArchieve,
        archieveCourseId,
        superAdminId,
        cycleAvailable,
        createdAt,
        studentCount,
        isEnrolled,
      ];
}