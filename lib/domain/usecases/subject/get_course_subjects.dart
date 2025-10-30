import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/subject.dart';
import '../../repositories/subject_repository.dart';

class GetCourseSubjects {
  final SubjectRepository repository;

  GetCourseSubjects(this.repository);

  Future<Either<Failure, List<CourseSubject>>> call(String courseId) async {
    return await repository.getCourseSubjects(courseId);
  }
}