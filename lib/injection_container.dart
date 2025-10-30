import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

// blocs
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/course/course_bloc.dart';
import 'presentation/blocs/profile/profile_bloc.dart';
import 'presentation/blocs/enrollment/enrollment_bloc.dart';

// UseCases - Auth
import 'domain/usecases/auth/check_auth_status.dart';
import 'domain/usecases/auth/check_user_exists.dart';
import 'domain/usecases/auth/verify_login.dart';
import 'domain/usecases/auth/signup.dart';
import 'domain/usecases/auth/forgot_password.dart';
import 'domain/usecases/auth/reset_password.dart';
import 'domain/usecases/auth/sign_out.dart';

// UseCases - Subject
import 'domain/repositories/subject_repository.dart';
import 'data/repositories/subject_repository_impl.dart';
import 'data/datasources/remote/subject_remote_datasource.dart';
import 'domain/usecases/subject/get_course_subjects.dart';
import 'domain/usecases/subject/get_archieved_courses.dart';
import 'presentation/blocs/subject/subject_bloc.dart';

// UseCases - Course
import 'domain/usecases/course/get_all_courses.dart';
import 'domain/usecases/course/get_enrolled_courses.dart';
import 'domain/usecases/course/redeem_course.dart';

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
import 'data/datasources/local/auth_local_datasource.dart';
import 'data/datasources/remote/custom_auth_remote_datasource.dart';
import 'data/datasources/remote/course_remote_datasource.dart';
import 'data/datasources/remote/user_remote_datasource.dart';

// Core
import 'core/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      checkAuthStatus: sl(),
      checkUserExists: sl(),
      verifyLogin: sl(),
      //login: sl(),
      signup: sl(),
      forgotPassword: sl(),
      signOut: sl(),
    ),
  );

  sl.registerFactory(
    () => EnrollmentBloc(getEnrolledCourses: sl(), redeemCourse: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => CheckUserExists(sl()));
  sl.registerLazySingleton(() => VerifyLogin(sl()));
  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      customAuthDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CustomAuthRemoteDataSource>(
    () => CustomAuthRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! ---------------- COURSE FEATURE ----------------

  // Bloc
  sl.registerFactory(
    () => CourseBloc(getAllCourses: sl(), getEnrolledCourses: sl()),
  );

  // Use case
  sl.registerLazySingleton(() => GetAllCourses(sl()));
  sl.registerLazySingleton(() => GetEnrolledCourses(sl()));
  sl.registerLazySingleton(() => RedeemCourse(sl()));

  // Repository
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data source
  sl.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(dio: sl()),
  );

  //! ---------------- USER/PROFILE FEATURE ----------------

  // Bloc
  sl.registerFactory(() => ProfileBloc(getUserProfile: sl()));

  // Use case
  sl.registerLazySingleton(() => GetUserProfile(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data source
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: sl()),
  );

  //! Features - Subject
  // BLoC
  sl.registerFactory(
    () => SubjectBloc(getCourseSubjects: sl(), getArchievedCourses: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCourseSubjects(sl()));
  sl.registerLazySingleton(() => GetArchievedCourses(sl()));

  // Repository
  sl.registerLazySingleton<SubjectRepository>(
    () => SubjectRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<SubjectRemoteDataSource>(
    () => SubjectRemoteDataSourceImpl(dio: sl()),
  );

  // Configure Dio with Cookie Manager
  sl.registerLazySingletonAsync<Dio>(() async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Setup cookie manager to persist cookies
    final appDocDir = await getApplicationDocumentsDirectory();
    final cookiePath = '${appDocDir.path}/.cookies/';
    final cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));

    dio.interceptors.add(CookieManager(cookieJar));

    // Add logging interceptor for debugging (remove in production)
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (log) => print(log),
      ),
    );

    return dio;
  });

  //! ---------------- CORE + EXTERNAL ----------------

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  await sl.isReady<Dio>();
}
