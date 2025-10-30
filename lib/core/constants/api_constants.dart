class ApiConstants {
  ApiConstants._();

  // Base URLs
  static const String authBaseUrl = 'http://10.0.2.2:3001/api/v1';
  static const String profileBaseUrl = 'https://profile.aparsclassroom.com';
  static const String courseBaseUrl = 'http://10.0.2.2:3001/api/v1/';
  static const String baseUrl = 'http://10.0.2.2:3001/api/v1/';

  // Auth Endpoints
  static const String checkUser = '/login'; // POST: email or phone
  static const String login = '/verify-login'; // POST: password
  static const String signup = '/signup'; // POST: name, email, phone, password
  static const String forgotPassword = '/forget-password'; // POST: only email
  static const String resetPassword = '/reset-password'; // POST: email, new password
  static const String logout = '/logout';

  // Profile Endpoints
  static const String userProfile = '/profile/info'; // GET: ?uid=xxx
  static const String updateProfile = '/profile/update'; // POST
}