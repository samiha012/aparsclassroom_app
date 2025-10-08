part of 'course_bloc.dart';

sealed class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

class LoadCoursesEvent extends CourseEvent {
  final String uid;

  const LoadCoursesEvent({required this.uid});

  @override
  List<Object?> get props => [uid];
}