import '../../domain/entities/enrolled_course.dart';
import 'course_model.dart';

class EnrolledCourseModel extends EnrolledCourse {
  const EnrolledCourseModel({
    required super.studentId,
    required super.courseId,
    required super.accessCode,
    required super.course,
    required super.studentName,
    required super.createdAt,
  });

  factory EnrolledCourseModel.fromJson(Map<String, dynamic> json) {
    final courseData = json['course'] as Map<String, dynamic>;
    
    final fullCourseData = {
      'id': json['courseId'],
      'courseId': json['courseId'],
      'productId': courseData['productId'],
      'productName': courseData['productName'],
      'productFullName': courseData['productFullName'],
      'ProductImage': courseData['ProductImage'],
      'Category': courseData['Category'],
      'SubCategory': courseData['SubCategory'],
      'currency_amount': courseData['currency_amount'],
      'Permalink': courseData['Permalink'],
      'facebookGroup': courseData['facebookGroup'],
      'Parent': courseData['Parent'],
      'Platinum': courseData['Platinum'],
      'markAsArchieve': courseData['markAsArchieve'],
      'archieveCourseId': courseData['archieveCourseId'],
      'cycleAvailable': courseData['cycleAvailable'],
      '_count': {'student': 0},
      'isEnrolled': true,
    };

    return EnrolledCourseModel(
      studentId: json['studentId'] as String,
      courseId: json['courseId'] as String,
      accessCode: json['accessCode'] as String,
      course: CourseModel.fromJson(fullCourseData),
      studentName: json['student']['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'courseId': courseId,
      'accessCode': accessCode,
      'course': (course as CourseModel).toJson(),
      'student': {'name': studentName},
      'createdAt': createdAt.toIso8601String(),
    };
  }
}