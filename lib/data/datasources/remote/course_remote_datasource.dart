import 'package:dio/dio.dart';
import '../../models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getAllCourses(String uid);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://crm.apars.shop';

  CourseRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CourseModel>> getAllCourses(String uid) async {
    try {
      //  uncomment this for production
      // final response = await dio.get('$baseUrl/product/all?uid=$uid');
      final response = await dio.get(
        '$baseUrl/product/all?uid=GbpNqKDUQqU5ZHo3qyEs2EvbtL32',
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is! Map || !data.containsKey('products')) {
          throw Exception('Invalid response format: missing "products" key');
        }

        final List<dynamic> courseList = data['products'] as List<dynamic>;

        return courseList
            .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
             .where((course) => course.status.toLowerCase() != 'disable')
            .toList();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }
}
