import 'package:equatable/equatable.dart';
import 'course.dart';

class EnrolledCourse extends Equatable {
  final String studentId;
  final String courseId;
  final String accessCode;
  final Course course;
  final String studentName;
  final DateTime createdAt;

  const EnrolledCourse({
    required this.studentId,
    required this.courseId,
    required this.accessCode,
    required this.course,
    required this.studentName,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        studentId,
        courseId,
        accessCode,
        course,
        studentName,
        createdAt,
      ];
}