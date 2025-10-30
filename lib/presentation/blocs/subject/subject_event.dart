part of 'subject_bloc.dart';

sealed class SubjectEvent extends Equatable {
  const SubjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadSubjectsEvent extends SubjectEvent {
  final String courseId;

  const LoadSubjectsEvent({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}