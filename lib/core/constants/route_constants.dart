class RouteConstants {
  // Prevent instantiation
  RouteConstants._();

  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String emailLogin = '/email-login';
  static const String checkUser = '/check-user';
  static const String passwordLogin = '/password-login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Main Routes
  static const String main = '/main';
  static const String home = '/home';
  static const String enrolledCourses = '/enrolled-courses';
  static const String community = '/community';
  static const String profile = '/profile';

  // Course Routes
  static const String courseDetails = '/course-details';
  static const String subjectList = '/subject-list';
  static const String chapterList = '/chapter-list';

  // Video Routes
  static const String videoPlayer = '/video-player';
  static const String pdfViewer = '/pdf-viewer';

  // Search
  static const String search = '/search';

  // Profile Routes
  static const String editProfile = '/edit-profile';
}