import 'dart:io';

void main() async {
  print('Setting up project structure...\n');

  // Create directories
  final directories = [
    'lib/domain/entities',
    'lib/domain/repositories',
    'lib/domain/usecases/auth',
    'lib/data/models',
    'lib/data/repositories',
    'lib/data/datasources/remote',
    'lib/data/datasources/local',
    'lib/core/errors',
    'lib/core/network',
    'lib/presentation/pages/auth',
    'lib/presentation/pages/main',
    'lib/presentation/pages/course',
    'lib/presentation/pages/video',
    'lib/presentation/pages/home',
    'lib/presentation/pages/profile',
    'assets/images',
  ];

  for (var dir in directories) {
    await Directory(dir).create(recursive: true);
    print('✓ Created directory: $dir');
  }

  print('\nCreating files...\n');

  // Create all necessary files
  await createFile('lib/domain/entities/user.dart', userEntity);
  await createFile('lib/core/errors/failures.dart', failures);
  await createFile('lib/domain/repositories/auth_repository.dart', authRepository);
  await createFile('lib/domain/usecases/auth/check_auth_status.dart', checkAuthStatus);
  await createFile('lib/domain/usecases/auth/sign_in_with_google.dart', signInWithGoogle);
  await createFile('lib/domain/usecases/auth/sign_in_with_email.dart', signInWithEmail);
  await createFile('lib/domain/usecases/auth/sign_out.dart', signOut);
  await createFile('lib/core/network/network_info.dart', networkInfo);
  await createFile('lib/data/models/user_model.dart', userModel);
  await createFile('lib/data/datasources/remote/auth_remote_datasource.dart', authRemoteDataSource);
  await createFile('lib/data/datasources/local/auth_local_datasource.dart', authLocalDataSource);
  await createFile('lib/data/repositories/auth_repository_impl.dart', authRepositoryImpl);
  
  // Create placeholder screens
  await createFile('lib/presentation/pages/auth/email_login_screen.dart', emailLoginScreen);
  await createFile('lib/presentation/pages/main/main_navigation_screen.dart', mainNavigationScreen);
  await createFile('lib/presentation/pages/course/course_details_screen.dart', courseDetailsScreen);
  await createFile('lib/presentation/pages/course/subject_list_screen.dart', subjectListScreen);
  await createFile('lib/presentation/pages/course/chapter_list_screen.dart', chapterListScreen);
  await createFile('lib/presentation/pages/video/video_player_screen.dart', videoPlayerScreen);
  await createFile('lib/presentation/pages/video/pdf_viewer_screen.dart', pdfViewerScreen);
  await createFile('lib/presentation/pages/home/search_screen.dart', searchScreen);
  await createFile('lib/presentation/pages/profile/edit_profile_screen.dart', editProfileScreen);

  print('\n✅ Project setup complete!');
  print('\nNext steps:');
  print('1. Add your logo to: assets/images/logo.png');
  print('2. Update Firebase config in: lib/core/config/firebase_config.dart');
  print('3. Run: flutter pub get');
  print('4. Run: flutter pub run flutter_native_splash:create');
  print('5. Run: flutter run');
}

Future<void> createFile(String path, String content) async {
  final file = File(path);
  await file.writeAsString(content);
  print('✓ Created file: $path');
}

// File contents
const userEntity = '''import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime? createdAt;

  const User({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl, createdAt];
}
''';

const failures = '''import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}
''';

const authRepository = '''import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User?>> checkAuthStatus();
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> signInWithEmail(String email, String password);
  Future<Either<Failure, void>> signOut();
}
''';

const checkAuthStatus = '''import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class CheckAuthStatus {
  final AuthRepository repository;

  CheckAuthStatus(this.repository);

  Future<Either<Failure, User?>> call() async {
    return await repository.checkAuthStatus();
  }
}
''';

const signInWithGoogle = '''import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.signInWithGoogle();
  }
}
''';

const signInWithEmail = '''import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class SignInWithEmail {
  final AuthRepository repository;

  SignInWithEmail(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) async {
    return await repository.signInWithEmail(email, password);
  }
}
''';

const signOut = '''import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}
''';

const networkInfo = '''import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({Connectivity? connectivity})
      : connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result.first != ConnectivityResult.none;
  }
}
''';

const userModel = '''import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      createdAt: user.createdAt,
    );
  }
}
''';

const authRemoteDataSource = '''import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithEmail(String email, String password);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    GoogleSignIn? googleSignIn,
  }) : googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await firestore.collection('users').doc(user.uid).get();
    
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }

    final userModel = UserModel(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      createdAt: DateTime.now(),
    );

    await firestore.collection('users').doc(user.uid).set(userModel.toJson());
    return userModel;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user!;

      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );

      await firestore.collection('users').doc(user.uid).set(
        userModel.toJson(),
        SetOptions(merge: true),
      );

      return userModel;
    } catch (e) {
      throw Exception('Failed to sign in with Google: \$e');
    }
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      final doc = await firestore.collection('users').doc(user.uid).get();
      
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }

      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );

      await firestore.collection('users').doc(user.uid).set(userModel.toJson());
      return userModel;
    } catch (e) {
      throw Exception('Failed to sign in with email: \$e');
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      firebaseAuth.signOut(),
      googleSignIn.signOut(),
    ]);
  }
}
''';

const authLocalDataSource = '''import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(_cachedUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      _cachedUserKey,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_cachedUserKey);
  }
}
''';

const authRepositoryImpl = '''import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User?>> checkAuthStatus() async {
    try {
      if (await networkInfo.isConnected) {
        final user = await remoteDataSource.getCurrentUser();
        if (user != null) {
          await localDataSource.cacheUser(user);
        }
        return Right(user);
      } else {
        final cachedUser = await localDataSource.getCachedUser();
        return Right(cachedUser);
      }
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final user = await remoteDataSource.signInWithGoogle();
      await localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final user = await remoteDataSource.signInWithEmail(email, password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
''';

// Placeholder screens
const emailLoginScreen = '''import 'package:flutter/material.dart';

class EmailLoginScreen extends StatelessWidget {
  const EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Login')),
      body: const Center(child: Text('Email Login Screen - TODO')),
    );
  }
}
''';

const mainNavigationScreen = '''import 'package:flutter/material.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Main Navigation Screen - TODO')),
    );
  }
}
''';

const courseDetailsScreen = '''import 'package:flutter/material.dart';

class CourseDetailsScreen extends StatelessWidget {
  final String courseId;
  
  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: Center(child: Text('Course Details Screen - \$courseId')),
    );
  }
}
''';

const subjectListScreen = '''import 'package:flutter/material.dart';

class SubjectListScreen extends StatelessWidget {
  final String courseId;
  final String courseName;
  
  const SubjectListScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(courseName)),
      body: const Center(child: Text('Subject List Screen - TODO')),
    );
  }
}
''';

const chapterListScreen = '''import 'package:flutter/material.dart';

class ChapterListScreen extends StatelessWidget {
  final String subjectId;
  final String subjectName;
  
  const ChapterListScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subjectName)),
      body: const Center(child: Text('Chapter List Screen - TODO')),
    );
  }
}
''';

const videoPlayerScreen = '''import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoId;
  final String? videoUrl;
  final String videoTitle;
  final String chapterId;
  
  const VideoPlayerScreen({
    super.key,
    required this.videoId,
    this.videoUrl,
    required this.videoTitle,
    required this.chapterId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(videoTitle)),
      body: const Center(child: Text('Video Player Screen - TODO')),
    );
  }
}
''';

const pdfViewerScreen = '''import 'package:flutter/material.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;
  final String pdfTitle;
  
  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.pdfTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pdfTitle)),
      body: const Center(child: Text('PDF Viewer Screen - TODO')),
    );
  }
}
''';

const searchScreen = '''import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(child: Text('Search Screen - TODO')),
    );
  }
}
''';

const editProfileScreen = '''import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile Screen - TODO')),
    );
  }
}
''';