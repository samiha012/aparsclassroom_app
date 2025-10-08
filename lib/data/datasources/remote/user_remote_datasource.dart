import 'package:dio/dio.dart';
import '../../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserProfile(String uid);
  //Future<UserModel> updateUserProfile(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://profile.aparsclassroom.com';

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> getUserProfile(String uid) async {
    try {
      //uncomment this line and comment the next line for production
      //final response = await dio.get('$baseUrl/profile/info?uid=$uid');
      final response = await dio.get('$baseUrl/profile/info?uid=mQCmR85vs7gQoEG1UBfGQVJv1cC3');

      if (response.statusCode == 200) {
        final data = response.data;
        
        // The API might return data in different formats, handle both
        if (data is Map<String, dynamic>) {
          // If the response has a nested structure
          final profileData = data['profile'] ?? data;
          return UserModel.fromJson(profileData as Map<String, dynamic>);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  // @override
  // Future<UserModel> updateUserProfile(UserModel user) async {
  //   try {
  //     final response = await dio.post(
  //       '$baseUrl/profile/update',
  //       data: user.toJson(),
  //     );

  //     if (response.statusCode == 200) {
  //       return UserModel.fromJson(response.data as Map<String, dynamic>);
  //     } else {
  //       throw Exception('Failed to update profile');
  //     }
  //   } catch (e) {
  //     throw Exception('Error updating profile: $e');
  //   }
  // }
}