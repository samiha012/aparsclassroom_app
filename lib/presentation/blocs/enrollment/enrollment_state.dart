part of 'enrollment_bloc.dart';

abstract class EnrollmentState extends Equatable {
  const EnrollmentState();

  @override
  List<Object> get props => [];
}

class EnrollmentInitial extends EnrollmentState {}

class EnrollmentLoading extends EnrollmentState {}

class EnrollmentLoaded extends EnrollmentState {
  final List<EnrolledCourse> enrolledCourses;

  const EnrollmentLoaded({required this.enrolledCourses});

  @override
  List<Object> get props => [enrolledCourses];
}

class EnrollmentError extends EnrollmentState {
  final String message;

  const EnrollmentError({required this.message});

  @override
  List<Object> get props => [message];
}

class RedeemingCourse extends EnrollmentState {}

class RedeemSuccess extends EnrollmentState {}

class RedeemError extends EnrollmentState {
  final String message;

  const RedeemError({required this.message});

  @override
  List<Object> get props => [message];
}