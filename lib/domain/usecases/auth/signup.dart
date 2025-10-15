import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class Signup {
  final AuthRepository repository;

  Signup(this.repository);

  Future<Either<Failure, User>> call({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    return await repository.signup(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
  }
}