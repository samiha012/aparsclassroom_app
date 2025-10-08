import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getUserProfile(String uid) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final user = await remoteDataSource.getUserProfile(uid);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, User>> updateUserProfile(User user) async {
  //   try {
  //     if (!await networkInfo.isConnected) {
  //       return const Left(NetworkFailure('No internet connection'));
  //     }

  //     final userModel = UserModel.fromEntity(user);
  //     final updatedUser = await remoteDataSource.updateUserProfile(userModel);
  //     return Right(updatedUser);
  //   } catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   }
  // }
}