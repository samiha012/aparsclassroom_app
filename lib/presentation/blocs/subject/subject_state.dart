part of 'subject_bloc.dart';

sealed class SubjectState extends Equatable {
  const SubjectState();

  @override
  List<Object?> get props => [];
}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectLoaded extends SubjectState {
  final List<CourseSubject> subjects;
  final List<ArchievedCourse> archievedCourses;

  const SubjectLoaded({
    required this.subjects,
    required this.archievedCourses,
  });

  @override
  List<Object?> get props => [subjects, archievedCourses];
}

class SubjectError extends SubjectState {
  final String message;

  const SubjectError({required this.message});

  @override
  List<Object?> get props => [message];
}