import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/usecases/course/get_all_courses.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetAllCourses getAllCourses;

  CourseBloc({required this.getAllCourses}) : super(CourseInitial()) {
    on<LoadCoursesEvent>(_onLoadCourses);
  }

  Future<void> _onLoadCourses(
    LoadCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());

    final result = await getAllCourses(event.uid);

    result.fold(
      (failure) => emit(CourseError(message: failure.message)),
      (courses) {
        // Filter out archived courses
        final activeCourses = courses
            .where((course) => !course.markAsArchieve)
            .toList();

        // Group courses by category
        final Map<String, List<Course>> groupedCourses = {};
        for (var course in activeCourses) {
          if (!groupedCourses.containsKey(course.category)) {
            groupedCourses[course.category] = [];
          }
          groupedCourses[course.category]!.add(course);
        }

        // Separate enrolled courses
        final enrolledCourses = activeCourses
            .where((course) => course.isEnrolled)
            .toList();

        emit(CourseLoaded(
          courses: activeCourses,
          groupedCourses: groupedCourses,
          enrolledCourses: enrolledCourses,
        ));
      },
    );
  }
}