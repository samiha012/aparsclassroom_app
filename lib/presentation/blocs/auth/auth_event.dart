part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class CheckUserExistsEvent extends AuthEvent {
  final String emailOrPhone;

  const CheckUserExistsEvent({required this.emailOrPhone});

  @override
  List<Object?> get props => [emailOrPhone];
}

class VerifyLoginEvent extends AuthEvent {
  final String password;

  const VerifyLoginEvent({required this.password});

  @override
  List<Object?> get props => [password];
}


class SignInWithGoogleEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String password;

  const LoginEvent({
    required this.password,
  });

  @override
  List<Object?> get props => [ password];
}

class SignupEvent extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;

  const SignupEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, phone, password];
}

class ForgotPasswordEvent extends AuthEvent {
  final String emailOrPhone;

  const ForgotPasswordEvent({required this.emailOrPhone});

  @override
  List<Object?> get props => [emailOrPhone];
}

class SignOutEvent extends AuthEvent {}