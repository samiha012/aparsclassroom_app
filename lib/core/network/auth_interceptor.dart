import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  AuthInterceptor({required this.storage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get stored access token
    final token = await storage.read(key: 'x-access-token');
    
    if (token != null) {
      options.headers['x-access-token'] = token;
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - refresh token logic can go here
    if (err.response?.statusCode == 401) {
      // Your refresh token is in httpOnly cookie
      // Backend should automatically check it
      // You might want to call a refresh endpoint here
    }

    super.onError(err, handler);
  }
}