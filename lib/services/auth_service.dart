import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///
class AuthService {
  ///
  AuthService(this.client);

  ///
  final SupabaseClient client;

  ///
  Session? get currentUserSession => client.auth.currentSession;

  ///
  Future<Session?> getInitialSession() async => currentUserSession;

  ///
  Future<Either<Failure, User>> signUpUser({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final AuthResponse response = await client.auth.signUp(
        password: password,
        email: email,
        data: <String, dynamic>{
          'full_name': name,
          'phone_number': phoneNumber,
          'email': email,
        },
      );
      if (response.user != null) {
        return right(response.user!);
      }
      return left(Failure('Unexpected error occurred'));
    } on AuthException catch (e) {
      print(e.toString());
      return left(mapAuthError(e));
    } catch (_) {
      return left(Failure('Something went wrong. Please try again.'));
    }
  }

  ///
  Future<Either<Failure, User>> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return right(response.user!);
      }
      return left(Failure('Unexpected error occurred'));
    } on AuthException catch (e) {
      return left(mapAuthError(e));
    } catch (_) {
      return left(Failure('Something went wrong. Please try again.'));
    }
  }

  ///
  Future<Either<Failure, bool>> forgotPassword({required String email}) async {
    try {
      await client.auth.resetPasswordForEmail(email);
      return right(true);
    } on AuthException catch (e) {
      return left(mapAuthError(e));
    }
  }

  ///
  Future<Either<Failure, bool>> logOutUser() async {
    try {
      await client.auth.signOut();
      return right(true);
    } on AuthException catch (e) {
      return left(mapAuthError(e));
    }
  }

  Failure mapAuthError(dynamic e) {
    if (e is AuthException) {
      final String msg = e.message.toLowerCase();

      final Map<String, String> errorMap = <String, String>{
        'invalid login credentials': 'Invalid email or password',
        'user already registered': 'Email is already registered',
        'email not confirmed': 'Please verify your email before logging in',
        'rate limit exceeded': 'Too many attempts. Try again later',
        'password should be at least': 'Password is too weak',
      };

      for (final MapEntry<String, String> entry in errorMap.entries) {
        if (msg.contains(entry.key)) {
          return Failure(entry.value);
        }
      }

      return Failure('Auth error: ${e.message}');
    }

    if (e is AuthRetryableFetchException) {
      return Failure('Network error. Please check your internet connection.');
    }

    return Failure('Unexpected auth error');
  }
}
