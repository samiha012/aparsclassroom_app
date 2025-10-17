import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getAllCourses(String uid);
  Future<CourseModel> getCourseDetails(String courseId);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final Dio dio;

  CourseRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CourseModel>> getAllCourses(String uid) async {
    try {
      final response = await dio.get('${ApiConstants.baseUrl}/course?limit=100');

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
}