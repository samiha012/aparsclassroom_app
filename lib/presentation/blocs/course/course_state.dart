part of 'course_bloc.dart';

sealed class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<Course> courses;
  final Map<String, List<Course>> groupedCourses;

  const CourseLoaded({
    required this.courses,
    required this.groupedCourses,
  });

  @override
  List<Object?> get props => [courses, groupedCourses];
}

class CourseError extends CourseState {
  final String message;

  const CourseError({required this.message});

  @override
  List<Object?> get props => [message];
}