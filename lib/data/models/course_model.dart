import '../../domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.courseId,
    required super.productId,
    required super.productName,
    required super.productFullName,
    super.productImage,
    required super.category,
    required super.subCategory,
    required super.currencyAmount,
    super.permalink,
    super.facebookGroup,
    super.parent,
    required super.platinum,
    required super.markAsArchieve,
    super.archieveCourseId,
    super.superAdminId,
    required super.cycleAvailable,
    super.createdAt,
    required super.studentCount,
    required super.isEnrolled,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productFullName: json['productFullName'] as String,
      productImage: json['ProductImage'] as String?,
      category: json['Category'] as String,
      subCategory: json['SubCategory'] as String,
      currencyAmount: (json['currency_amount'] as num).toDouble(),
      permalink: json['Permalink'] as String?,
      facebookGroup: json['facebookGroup'] as String?,
      parent: json['Parent'] as String?,
      platinum: (json['Platinum'] as num).toInt(),
      markAsArchieve: json['markAsArchieve'] as bool,
      archieveCourseId: json['archieveCourseId'] as String?,
      superAdminId: json['superAdminId'] as String?,
      cycleAvailable: json['cycleAvailable'] as bool,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      studentCount: json['_count'] != null && json['_count']['student'] != null
          ? (json['_count']['student'] as num).toInt()
          : 0,
      isEnrolled: json['isEnrolled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'productId': productId,
      'productName': productName,
      'productFullName': productFullName,
      'ProductImage': productImage,
      'Category': category,
      'SubCategory': subCategory,
      'currency_amount': currencyAmount,
      'Permalink': permalink,
      'facebookGroup': facebookGroup,
      'Parent': parent,
      'Platinum': platinum,
      'markAsArchieve': markAsArchieve,
      'archieveCourseId': archieveCourseId,
      'superAdminId': superAdminId,
      'cycleAvailable': cycleAvailable,
      'createdAt': createdAt?.toIso8601String(),
      '_count': {
        'student': studentCount,
      },
      'isEnrolled': isEnrolled,
    };
  }
}