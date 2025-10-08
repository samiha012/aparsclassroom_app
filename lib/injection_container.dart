import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

// BLoCs
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/course/course_bloc.dart';
import 'presentation/blocs/profile/profile_bloc.dart';

// UseCases - Auth
import 'domain/usecases/auth/check_auth_status.dart';
import 'domain/usecases/auth/sign_in_with_google.dart';
import 'domain/usecases/auth/sign_in_with_email.dart';
import 'domain/usecases/auth/sign_out.dart';

// UseCases - Course
import 'domain/usecases/course/get_all_courses.dart';

// UseCases - User
import 'domain/usecases/user/get_user_profile.dart';

// Repositories
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/course_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/course_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';

// DataSources
import 'data/datasources/remote/auth_remote_datasource.dart';
import 'data/datasources/local/auth_local_datasource.dart';
import 'data/datasources/remote/course_remote_datasource.dart';
import 'data/datasources/remote/user_remote_datasource.dart';

// Core
import 'core/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      checkAuthStatus: sl(),
      signInWithGoogle: sl(),
      signInWithEmail: sl(),
      signOut: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  //! Features - Course
  // BLoC
  sl.registerFactory(
    () => CourseBloc(
      getAllCourses: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllCourses(sl()));

  // Repository
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(
      dio: sl(),
    ),
  );

  //! Features - User/Profile
  // BLoC
  sl.registerFactory(
    () => ProfileBloc(
      getUserProfile: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserProfile(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      dio: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton(() => Dio());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}