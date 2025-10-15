import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/auth/check_auth_status.dart';
import '../../../domain/usecases/auth/check_user_exists.dart';
//import '../../../domain/usecases/auth/sign_in_with_google.dart';
import '../../../domain/usecases/auth/verify_login.dart';
import '../../../domain/usecases/auth/signup.dart';
import '../../../domain/usecases/auth/forgot_password.dart';
import '../../../domain/usecases/auth/sign_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatus checkAuthStatus;
  final CheckUserExists checkUserExists;
  //final SignInWithGoogle signInWithGoogle;
  final VerifyLogin verifyLogin;
  final Signup signup;
  final ForgotPassword forgotPassword;
  final SignOut signOut;

  AuthBloc({
    required this.checkAuthStatus,
    required this.checkUserExists,
    required this.verifyLogin,
    //required this.signInWithGoogle,
    required this.signup,
    required this.forgotPassword,
    required this.signOut,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<CheckUserExistsEvent>(_onCheckUserExists);
    //on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    //on<LoginEvent>(_onLogin);
    on<VerifyLoginEvent>(_onVerifyLogin);
    on<SignupEvent>(_onSignup);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await checkAuthStatus();

    result.fold((failure) => emit(Unauthenticated()), (user) {
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> _onCheckUserExists(
    CheckUserExistsEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await checkUserExists(event.emailOrPhone);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (exists) =>
          emit(UserExistsCheck(exists: exists, identifier: event.emailOrPhone)),
    );
  }

  Future<void> _onVerifyLogin(
    VerifyLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await verifyLogin(
      password: event.password,
    ); // ensure this calls /verify-login
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  // Future<void> _onSignInWithGoogle(
  //   SignInWithGoogleEvent event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoading());

  //   final result = await signInWithGoogle();

  //   result.fold(
  //     (failure) => emit(AuthError(message: failure.message)),
  //     (user) => emit(Authenticated(user: user)),
  //   );
  // }

  // Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
  //   emit(AuthLoading());

  //   try {
  //     // Step 1: Check if user exists (sets cookie automatically)
  //     final existsResult = await checkUserExists(event.password);
  //     existsResult.fold(
  //       (failure) => emit(AuthError(message: failure.message)),
  //       (exists) async {
  //         if (!exists) {
  //           emit(AuthError(message: "User not found, please sign up."));
  //           return;
  //         }

  //         // Step 2: Verify password
  //         final loginResult = await login(password: event.password);
  //         loginResult.fold(
  //           (failure) => emit(AuthError(message: failure.message)),
  //           (user) => emit(Authenticated(user: user)),
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     emit(AuthError(message: e.toString()));
  //   }
  // }

  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await signup(
      name: event.name,
      email: event.email,
      phone: event.phone,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await forgotPassword(event.emailOrPhone);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(PasswordResetSent()),
    );
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    await signOut();
    emit(Unauthenticated());
  }
}
