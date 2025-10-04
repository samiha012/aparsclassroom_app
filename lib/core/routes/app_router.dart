import 'package:flutter/material.dart';
import '../../presentation/pages/splash/splash_screen.dart';
import '../../presentation/pages/auth/login_screen.dart';
import '../../presentation/pages/auth/email_login_screen.dart';
import '../../presentation/pages/main/main_navigation_screen.dart';
import '../../presentation/pages/course/course_details_screen.dart';
import '../../presentation/pages/course/subject_list_screen.dart';
import '../../presentation/pages/course/chapter_list_screen.dart';
import '../../presentation/pages/video/video_player_screen.dart';
import '../../presentation/pages/video/pdf_viewer_screen.dart';
import '../../presentation/pages/home/search_screen.dart';
import '../../presentation/pages/profile/edit_profile_screen.dart';
import '../constants/route_constants.dart';

class AppRouter {
  // Prevent instantiation
  AppRouter._();

  static const String splash = RouteConstants.splash;
  static const String login = RouteConstants.login;
  static const String main = RouteConstants.main;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case RouteConstants.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case RouteConstants.emailLogin:
        return MaterialPageRoute(
          builder: (_) => const EmailLoginScreen(),
        );

      case RouteConstants.main:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        );

      case RouteConstants.courseDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CourseDetailsScreen(
            courseId: args['courseId'] as String,
          ),
        );

      case RouteConstants.subjectList:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SubjectListScreen(
            courseId: args['courseId'] as String,
            courseName: args['courseName'] as String,
          ),
        );

      case RouteConstants.chapterList:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChapterListScreen(
            subjectId: args['subjectId'] as String,
            subjectName: args['subjectName'] as String,
          ),
        );

      case RouteConstants.videoPlayer:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => VideoPlayerScreen(
            videoId: args['videoId'] as String,
            videoUrl: args['videoUrl'] as String?,
            videoTitle: args['videoTitle'] as String,
            chapterId: args['chapterId'] as String,
          ),
        );

      case RouteConstants.pdfViewer:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PdfViewerScreen(
            pdfUrl: args['pdfUrl'] as String,
            pdfTitle: args['pdfTitle'] as String,
          ),
        );

      case RouteConstants.search:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
        );

      case RouteConstants.editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}