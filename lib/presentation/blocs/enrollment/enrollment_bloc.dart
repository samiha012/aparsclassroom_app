import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/enrolled_course.dart';
import '../../../domain/usecases/course/get_enrolled_courses.dart';
import '../../../domain/usecases/course/redeem_course.dart';

part 'enrollment_event.dart';
part 'enrollment_state.dart';

class EnrollmentBloc extends Bloc<EnrollmentEvent, EnrollmentState> {
  final GetEnrolledCourses getEnrolledCourses;
  final RedeemCourse redeemCourse;

  EnrollmentBloc({
    required this.getEnrolledCourses,
    required this.redeemCourse,
  }) : super(EnrollmentInitial()) {
    on<LoadEnrolledCoursesEvent>(_onLoadEnrolledCourses);
    on<RedeemCourseEvent>(_onRedeemCourse);
  }

  Future<void> _onLoadEnrolledCourses(
    LoadEnrolledCoursesEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(EnrollmentLoading());

    final result = await getEnrolledCourses();

    result.fold(
      (failure) => emit(EnrollmentError(message: failure.message)),
      (courses) => emit(EnrollmentLoaded(enrolledCourses: courses)),
    );
  }

  Future<void> _onRedeemCourse(
    RedeemCourseEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(RedeemingCourse());

    final result = await redeemCourse(event.accessCode);

    result.fold(
      (failure) => emit(RedeemError(message: failure.message)),
      (success) {
        if (success) {
          emit(RedeemSuccess());
          // Reload enrolled courses
          add(LoadEnrolledCoursesEvent());
        } else {
          emit(const RedeemError(message: 'Failed to redeem course'));
        }
      },
    );
  }
}