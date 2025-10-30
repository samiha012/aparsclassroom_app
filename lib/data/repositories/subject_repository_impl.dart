import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/subject.dart';
import '../../domain/repositories/subject_repository.dart';
import '../datasources/remote/subject_remote_datasource.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SubjectRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CourseSubject>>> getCourseSubjects(String courseId) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final subjects = await remoteDataSource.getCourseSubjects(courseId);
      return Right(subjects);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ArchievedCourse>>> getArchievedCourses(String courseId) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final courses = await remoteDataSource.getArchievedCourses(courseId);
      return Right(courses);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}