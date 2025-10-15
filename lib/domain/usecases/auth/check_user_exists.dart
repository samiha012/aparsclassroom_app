import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

class CheckUserExists {
  final AuthRepository repository;

  CheckUserExists(this.repository);

  Future<Either<Failure, bool>> call(String emailOrPhone) async {
    return await repository.checkUserExists(emailOrPhone);
  }
}