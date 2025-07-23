part of 'auth_cubit.dart';

///
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => <Object?>[];
}

class AuthLoading extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthFailureState extends AuthState {
  final String msg;
  AuthFailureState(this.msg);
  @override
  List<Object?> get props => <Object?>[msg];
}

class GetUserDetailsSuccess extends AuthState {
  GetUserDetailsSuccess(this.user);
  final UserModel user;
  @override
  List<Object?> get props => <Object?>[user];
}

class GetUserDetailsFailure extends AuthState {
  final String msg;
  GetUserDetailsFailure(this.msg);
  @override
  List<Object?> get props => <Object?>[msg];
}

class AuthInitialState extends AuthState {}

class SessionNotFoundState extends AuthState {}

class AuthForgotPassSuccess extends AuthState {}

class AuthForgotPassFailure extends AuthState {
  final String msg;
  AuthForgotPassFailure(this.msg);
  @override
  List<Object?> get props => <Object?>[msg];
}
