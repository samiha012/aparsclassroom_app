import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/enrolled_course.dart';
import '../../repositories/course_repository.dart';

class GetEnrolledCourses {
  final CourseRepository repository;

  GetEnrolledCourses(this.repository);

  Future<Either<Failure, List<EnrolledCourse>>> call() async {
    return await repository.getEnrolledCourses();
  }
}