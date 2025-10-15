import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/custom_auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final CustomAuthRemoteDataSource customAuthDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.customAuthDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User?>> checkAuthStatus() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) return Right(cachedUser);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkUserExists(String emailOrPhone) async {
    try {
      if (!await networkInfo.isConnected) return const Left(NetworkFailure('No internet'));
      final exists = await customAuthDataSource.checkUserExists(emailOrPhone);
      return Right(exists);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> verifyLogin(String password) async {
    try {
      if (!await networkInfo.isConnected) return const Left(NetworkFailure('No internet'));
      final user = await customAuthDataSource.verifyLogin(password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      if (!await networkInfo.isConnected) return const Left(NetworkFailure('No internet'));
      final user = await customAuthDataSource.signup(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      await localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String emailOrPhone) async {
    try {
      if (!await networkInfo.isConnected) return const Left(NetworkFailure('No internet'));
      await customAuthDataSource.forgotPassword(emailOrPhone);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String token, String newPassword) async {
    try {
      if (!await networkInfo.isConnected) return const Left(NetworkFailure('No internet'));
      await customAuthDataSource.resetPassword(token, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await Future.wait([
        customAuthDataSource.logout(),
        localDataSource.clearCache(),
      ]);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
