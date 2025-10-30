import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/subject.dart';

abstract class SubjectRepository {
  Future<Either<Failure, List<CourseSubject>>> getCourseSubjects(String courseId);
  Future<Either<Failure, List<ArchievedCourse>>> getArchievedCourses(String courseId);
}