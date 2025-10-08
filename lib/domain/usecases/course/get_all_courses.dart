import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/course.dart';
import '../../repositories/course_repository.dart';

class GetAllCourses {
  final CourseRepository repository;

  GetAllCourses(this.repository);

  Future<Either<Failure, List<Course>>> call(String uid) async {
    return await repository.getAllCourses(uid);
  }
}