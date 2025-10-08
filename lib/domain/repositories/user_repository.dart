import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserProfile(String uid);
  //Future<Either<Failure, User>> updateUserProfile(User user);
}