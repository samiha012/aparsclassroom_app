import '../../domain/entities/subject.dart';

class CourseSubjectModel extends CourseSubject {
  const CourseSubjectModel({
    required super.id,
    super.title,
    super.courseSubjectImage,
    required super.createdAt,
    required super.subject,
    required super.course,
  });

  factory CourseSubjectModel.fromJson(Map<String, dynamic> json) {
    return CourseSubjectModel(
      id: json['id'] as String,
      title: json['title'] as String?,
      courseSubjectImage: json['courseSubjectImage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      subject: SubjectInfoModel.fromJson(json['subject'] as Map<String, dynamic>),
      course: CourseInfoModel.fromJson(json['course'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'courseSubjectImage': courseSubjectImage,
      'createdAt': createdAt.toIso8601String(),
      'subject': (subject as SubjectInfoModel).toJson(),
      'course': (course as CourseInfoModel).toJson(),
    };
  }
}

class SubjectInfoModel extends SubjectInfo {
  const SubjectInfoModel({
    required super.id,
    required super.title,
    super.subjectImage,
    required super.createdAt,
  });

  factory SubjectInfoModel.fromJson(Map<String, dynamic> json) {
    return SubjectInfoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subjectImage: json['subjectImage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subjectImage': subjectImage,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class CourseInfoModel extends CourseInfo {
  const CourseInfoModel({
    required super.id,
    required super.courseId,
    required super.productId,
    required super.productName,
    required super.productFullName,
    super.productImage,
    required super.category,
    required super.subCategory,
    required super.currencyAmount,
    super.parent,
    required super.platinum,
    required super.markAsArchieve,
    super.archieveCourseId,
    super.permalink,
    super.facebookGroup,
    required super.createdAt,
  });

  factory CourseInfoModel.fromJson(Map<String, dynamic> json) {
    return CourseInfoModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productFullName: json['productFullName'] as String,
      productImage: json['ProductImage'] as String?,
      category: json['Category'] as String,
      subCategory: json['SubCategory'] as String,
      currencyAmount: (json['currency_amount'] as num).toDouble(),
      parent: json['Parent'] as String?,
      platinum: (json['Platinum'] as num).toInt(),
      markAsArchieve: json['markAsArchieve'] as bool,
      archieveCourseId: json['archieveCourseId'] as String?,
      permalink: json['Permalink'] as String?,
      facebookGroup: json['facebookGroup'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
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
      'Parent': parent,
      'Platinum': platinum,
      'markAsArchieve': markAsArchieve,
      'archieveCourseId': archieveCourseId,
      'Permalink': permalink,
      'facebookGroup': facebookGroup,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ArchievedCourseModel extends ArchievedCourse {
  const ArchievedCourseModel({
    required super.id,
    required super.courseId,
    required super.productId,
    required super.productName,
    required super.productFullName,
    super.productImage,
    required super.category,
    required super.subCategory,
    required super.markAsArchieve,
    super.createdAt,
  });

  factory ArchievedCourseModel.fromJson(Map<String, dynamic> json) {
    return ArchievedCourseModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productFullName: json['productFullName'] as String,
      productImage: json['ProductImage'] as String?,
      category: json['Category'] as String,
      subCategory: json['SubCategory'] as String,
      markAsArchieve: json['markAsArchieve'] as bool,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
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
      'markAsArchieve': markAsArchieve,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}