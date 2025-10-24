part of 'enrollment_bloc.dart';

abstract class EnrollmentEvent extends Equatable {
  const EnrollmentEvent();

  @override
  List<Object> get props => [];
}

class LoadEnrolledCoursesEvent extends EnrollmentEvent {
  const LoadEnrolledCoursesEvent();
}

class RedeemCourseEvent extends EnrollmentEvent {
  final String accessCode;

  const RedeemCourseEvent({required this.accessCode});

  @override
  List<Object> get props => [accessCode];
}