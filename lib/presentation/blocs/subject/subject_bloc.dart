import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/subject.dart';
import '../../../domain/usecases/subject/get_course_subjects.dart';
import '../../../domain/usecases/subject/get_archieved_courses.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final GetCourseSubjects getCourseSubjects;
  final GetArchievedCourses getArchievedCourses;

  SubjectBloc({
    required this.getCourseSubjects,
    required this.getArchievedCourses,
  }) : super(SubjectInitial()) {
    on<LoadSubjectsEvent>(_onLoadSubjects);
  }

  Future<void> _onLoadSubjects(
    LoadSubjectsEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());

    final subjectsResult = await getCourseSubjects(event.courseId);

    if (subjectsResult.isLeft()) {
      final failure = subjectsResult.fold(
        (l) => l,
        (r) => null,
      );
      emit(SubjectError(message: failure?.message ?? 'Unknown error'));
      return;
    }

    final subjects = subjectsResult.getOrElse(() => []);

    final archievedResult = await getArchievedCourses(event.courseId);
    final archievedCourses = archievedResult.fold<List<ArchievedCourse>>(
      (failure) => [], // Return empty list on failure
      (courses) => courses,
    );

    emit(SubjectLoaded(
      subjects: subjects,
      archievedCourses: archievedCourses,
    ));
  }
}