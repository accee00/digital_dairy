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
