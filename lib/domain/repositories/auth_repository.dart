import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User?>> checkAuthStatus();
  Future<Either<Failure, bool>> checkUserExists(String emailOrPhone);
  //Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> verifyLogin(String password);
  Future<Either<Failure, User>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
  Future<Either<Failure, void>> forgotPassword(String emailOrPhone);
  Future<Either<Failure, void>> resetPassword(String token, String newPassword);
  Future<Either<Failure, void>> signOut();
}
