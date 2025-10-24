import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/course_model.dart';
import '../../models/enrolled_course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getAllCourses(String uid);
  Future<CourseModel> getCourseDetails(String courseId);
  Future<List<EnrolledCourseModel>> getEnrolledCourses();
  Future<bool> redeemCourse(String accessCode);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final Dio dio;

  CourseRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CourseModel>> getAllCourses(String uid) async {
    try {
      final response = await dio.get('${ApiConstants.baseUrl}course?limit=100');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        final List<dynamic> courses = data['data'] as List;
        
        return courses
            .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  @override
  Future<CourseModel> getCourseDetails(String courseId) async {
    try {
      final response = await dio.get('${ApiConstants.authBaseUrl}/product/$courseId');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        return CourseModel.fromJson(data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load course details');
      }
    } catch (e) {
      throw Exception('Error fetching course details: $e');
    }
  }

  @override
  Future<List<EnrolledCourseModel>> getEnrolledCourses() async {
    try {
      final response = await dio.get('${ApiConstants.baseUrl}student/my-courses');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        final List<dynamic> courses = data['data'] as List;
        
        return courses
            .map((json) => EnrolledCourseModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load enrolled courses');
      }
    } catch (e) {
      throw Exception('Error fetching enrolled courses: $e');
    }
  }

  @override
  Future<bool> redeemCourse(String accessCode) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}student/course/redeem',
        data: {'accessCode': accessCode},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as bool;
      } else {
        final message = response.data['message'] ?? 'Failed to redeem course';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Error redeeming course: $e');
    }
  }
}