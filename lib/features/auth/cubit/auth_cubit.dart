import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/features/auth/model/user.dart';
import 'package:digital_dairy/services/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/src/either.dart';

part 'auth_state.dart';

///
class AuthCubit extends Cubit<AuthState> {
  ///
  AuthCubit(this.authService) : super(AuthFailureState('An Unexpected error!'));

  ///
  final AuthService authService;

  ///
  Future<void> signUpUser({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    emit(AuthLoading());
    final Either<Failure, void> response = await authService.signUpUser(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
    response.fold(
      (Failure failure) => emit(AuthFailureState(failure.message)),
      (void success) => emit(AuthSuccessState()),
    );
  }

  ///
  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final Either<Failure, void> response = await authService.signInUser(
      email: email,
      password: password,
    );
    response.fold(
      (Failure failure) => emit(AuthFailureState(failure.message)),
      (void success) => emit(AuthSuccessState()),
    );
  }
}
