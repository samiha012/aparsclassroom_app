import 'package:dio/dio.dart';
import '../../models/subject_model.dart';
import '../../../core/constants/api_constants.dart';

abstract class SubjectRemoteDataSource {
  Future<List<CourseSubjectModel>> getCourseSubjects(String courseId);
  Future<List<ArchievedCourseModel>> getArchievedCourses(String courseId);
}

class SubjectRemoteDataSourceImpl implements SubjectRemoteDataSource {
  final Dio dio;

  SubjectRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CourseSubjectModel>> getCourseSubjects(String courseId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}course-subject/subjects/$courseId?limit=100',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> subjects = response.data['data'] as List;

        return subjects
            .map(
              (json) =>
                  CourseSubjectModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('Failed to load subjects');
      }
    } catch (e) {
      throw Exception('Error fetching subjects: $e');
    }
  }

  @override
  Future<List<ArchievedCourseModel>> getArchievedCourses(
    String courseId,
  ) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}course/get-all/archieve-courses/$courseId',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];

        // Handle single object response
        if (data != null) {
          if (data is Map<String, dynamic>) {
            // Single object response
            return [ArchievedCourseModel.fromJson(data)];
          } else if (data is List) {
            // List response
            return data
                .map(
                  (json) => ArchievedCourseModel.fromJson(
                    json as Map<String, dynamic>,
                  ),
                )
                .toList();
          }
        }

        return [];
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to load archived courses',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception(
        e.response?.data['message'] ?? 'Error fetching archived courses',
      );
    } catch (e) {
      throw Exception('Error fetching archived courses: $e');
    }
  }
}
