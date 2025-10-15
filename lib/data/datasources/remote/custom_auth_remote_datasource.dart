import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../../models/user_model.dart';
import '../../../core/constants/api_constants.dart';

abstract class CustomAuthRemoteDataSource {
  Future<bool> checkUserExists(String emailOrPhone); 
  Future<UserModel> verifyLogin(String password);   
  Future<UserModel> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
  Future<void> forgotPassword(String emailOrPhone);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> logout();
}

class CustomAuthRemoteDataSourceImpl implements CustomAuthRemoteDataSource {
  final Dio dio;
  final CookieJar cookieJar = CookieJar();

  CustomAuthRemoteDataSourceImpl({required this.dio}) {
    dio.interceptors.add(CookieManager(cookieJar));
  }

  /// Step 1: Check if user exists
  @override
  Future<bool> checkUserExists(String emailOrPhone) async {
    try {
      final response = await dio.post(
        '${ApiConstants.authBaseUrl}${ApiConstants.checkUser}',
        data: {'emailOrPhone': emailOrPhone},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return true; // User exists, cookie automatically set
      } else if (response.data['success'] == false) {
        return false; // User not found
      } else {
        throw Exception('Unexpected response from server');
      }
    } catch (e) {
      print('Error checking user: $e');
      throw Exception('Error checking user: $e');
    }
  }

  /// Step 2: Verify login with password
  @override
  Future<UserModel> verifyLogin(String password) async {
    try {
      final response = await dio.post(
        '${ApiConstants.authBaseUrl}${ApiConstants.login}',
        data: {'passOrOtp': password},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final token = data['authToken'] as String;

        // Store token for future API calls
        dio.options.headers['Authorization'] = 'Bearer $token';
        return UserModel.fromJson(data);
      } else {
        final message = response.data['message'] ?? 'Invalid password';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<UserModel> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '${ApiConstants.authBaseUrl}${ApiConstants.signup}',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] as Map<String, dynamic>;
        final token = data['authToken'] as String;

        dio.options.headers['Authorization'] = 'Bearer $token';
        return UserModel.fromJson(data);
      } else {
        throw Exception('Signup failed: ${response.data['message']}');
      }
    } catch (e) {
      throw Exception('Signup error: $e');
    }
  }

  @override
  Future<void> forgotPassword(String emailOrPhone) async {
    try {
      final response = await dio.post(
        '${ApiConstants.authBaseUrl}${ApiConstants.forgotPassword}',
        data: {'emailOrPhone': emailOrPhone},
      );

      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Failed to send reset link');
      }
    } catch (e) {
      throw Exception('Forgot password error: $e');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      final response = await dio.post(
        '${ApiConstants.authBaseUrl}${ApiConstants.resetPassword}',
        data: {'token': token, 'password': newPassword},
      );

      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      throw Exception('Reset password error: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('${ApiConstants.authBaseUrl}${ApiConstants.logout}');
      dio.options.headers.remove('Authorization');
      cookieJar.deleteAll();
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }
}
