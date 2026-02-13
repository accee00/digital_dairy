part of 'auth_cubit.dart';

/// Base class for all authentication states.
sealed class AuthState extends Equatable {
  /// Creates an [AuthState].
  const AuthState();

  @override
  List<Object?> get props => <Object?>[];
}

/// State indicating authentication is in progress.
class AuthLoading extends AuthState {}

/// State indicating successful authentication.
class AuthSuccessState extends AuthState {
  /// Creates an [AuthSuccessState] with the authenticated [user].
  const AuthSuccessState(this.user);

  /// The authenticated user.
  final User user;
}

/// State indicating authentication failure.
class AuthFailureState extends AuthState {
  /// Creates an [AuthFailureState] with the error [msg].
  const AuthFailureState(this.msg);

  /// The error message.
  final String msg;

  @override
  List<Object?> get props => <Object?>[msg];
}

/// State indicating successful retrieval of user details.
class GetUserDetailsSuccess extends AuthState {
  /// Creates a [GetUserDetailsSuccess] with the [user] details.
  const GetUserDetailsSuccess(this.user);

  /// The user model with details.
  final UserModel user;

  @override
  List<Object?> get props => <Object?>[user];
}

/// State indicating failure to retrieve user details.
class GetUserDetailsFailure extends AuthState {
  /// Creates a [GetUserDetailsFailure] with the error [msg].
  const GetUserDetailsFailure(this.msg);

  /// The error message.
  final String msg;

  @override
  List<Object?> get props => <Object?>[msg];
}

/// Initial authentication state.
class AuthInitialState extends AuthState {}

/// State indicating no session was found.
class SessionNotFoundState extends AuthState {}

/// State indicating password reset email was sent successfully.
class AuthForgotPassSuccess extends AuthState {}

/// State indicating password reset request failed.
class AuthForgotPassFailure extends AuthState {
  /// Creates an [AuthForgotPassFailure] with the error [msg].
  const AuthForgotPassFailure(this.msg);

  /// The error message.
  final String msg;

  @override
  List<Object?> get props => <Object?>[msg];
}

///
class AuthLoggedOut extends AuthState {}
