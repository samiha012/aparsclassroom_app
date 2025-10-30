import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/subject.dart';
import '../../repositories/subject_repository.dart';

class GetArchievedCourses {
  final SubjectRepository repository;

  GetArchievedCourses(this.repository);

  Future<Either<Failure, List<ArchievedCourse>>> call(String courseId) async {
    return await repository.getArchievedCourses(courseId);
  }
}