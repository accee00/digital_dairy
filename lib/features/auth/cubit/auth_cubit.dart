import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/features/auth/model/user.dart';
import 'package:digital_dairy/services/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.dart';

/// Cubit for managing authentication state.
class AuthCubit extends Cubit<AuthState> {
  /// Creates an [AuthCubit] with the given [authService].
  AuthCubit(this.authService)
    : super(const AuthFailureState('An Unexpected error!'));

  /// The authentication service used for auth operations.
  final AuthService authService;

  /// Signs up a new user with the provided credentials.
  Future<void> signUpUser({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    emit(AuthLoading());
    final Either<Failure, User> response = await authService.signUpUser(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
    response.fold(
      (Failure failure) => emit(AuthFailureState(failure.message)),
      (User user) => emit(AuthSuccessState(user)),
    );
  }

  /// Signs in an existing user with the provided credentials.
  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final Either<Failure, User> response = await authService.signInUser(
      email: email,
      password: password,
    );

    response.fold(
      (Failure failure) => emit(AuthFailureState(failure.message)),
      (User user) => emit(AuthSuccessState(user)),
    );
  }

  /// Initiates password reset for the given email.
  Future<void> forgotPassword({required String email}) async {
    final Either<Failure, bool> response = await authService.forgotPassword(
      email: email,
    );
    response.fold(
      (Failure failure) => emit(AuthForgotPassFailure(failure.message)),
      (bool success) => emit(AuthForgotPassSuccess()),
    );
  }

  /// Checks for a persisted session and emits the appropriate state.
  Future<void> checkPersistedSession() async {
    emit(AuthLoading());
    try {
      final Session? session = await authService.getInitialSession();
      if (session != null) {
        logger.info('[Session from Auth Cubit]=> $session');
        emit(AuthSuccessState(session.user));
      } else {
        emit(SessionNotFoundState());
      }
    } catch (e) {
      emit(const AuthFailureState('Session check failed'));
    }
  }

  ///
  Future<void> logOutUser() async {
    emit(AuthLoading());
    final Either<Failure, bool> response = await authService.logOutUser();
    response.fold(
      (Failure failure) => emit(AuthFailureState(failure.message)),
      (bool success) => emit(AuthLoggedOut()),
    );
  }
}
