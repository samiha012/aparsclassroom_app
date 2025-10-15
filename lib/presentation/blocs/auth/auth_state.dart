part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class UserExistsCheck extends AuthState {
  final bool exists;
  final String identifier;

  const UserExistsCheck({
    required this.exists,
    required this.identifier,
  });

  @override
  List<Object?> get props => [exists, identifier];
}

class PasswordVerificationRequired extends AuthState {
  final String identifier;

  PasswordVerificationRequired({required this.identifier});

  @override
  List<Object?> get props => [identifier];
}


class PasswordResetSent extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}