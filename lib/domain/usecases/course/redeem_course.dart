import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/course_repository.dart';

class RedeemCourse {
  final CourseRepository repository;

  RedeemCourse(this.repository);

  Future<Either<Failure, bool>> call(String accessCode) async {
    return await repository.redeemCourse(accessCode);
  }
}