import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/course.dart';
import '../entities/enrolled_course.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<Course>>> getAllCourses(String uid);
  //Future<Either<Failure, Course>> getCourseDetails(String courseId);
  Future<Either<Failure, List<EnrolledCourse>>> getEnrolledCourses();
  Future<Either<Failure, bool>> redeemCourse(String accessCode);
}