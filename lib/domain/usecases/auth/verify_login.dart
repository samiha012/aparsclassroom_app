import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class VerifyLogin {
  final AuthRepository repository;

  VerifyLogin(this.repository);

  Future<Either<Failure, User>> call({
    required String password,
  }) async {
    return await repository.verifyLogin(password);
  }
}