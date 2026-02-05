import 'dart:io';

import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/features/auth/model/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Handles authentication and user profile operations.
class AuthService {
  /// Creates an instance of [AuthService].
  AuthService(this._client);

  /// Supabase client instance.
  final SupabaseClient _client;

  /// Returns the current authenticated session.
  Session? get _session => _client.auth.currentSession;

  /// Returns the initial authentication session if available.
  Future<Session?> getInitialSession() async => _session;

  /// Registers a new user with email and password.
  ///
  /// Returns a [User] on success or [Failure] on error.
  Future<Either<Failure, User>> signUpUser({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signUp(
        email: email,
        password: password,
        data: <String, dynamic>{'name': name, 'phone_number': phoneNumber},
      );

      final User? user = response.user;

      if (user == null) {
        return left(Failure('Sign up failed'));
      }

      return right(user);
    } on AuthException catch (e) {
      return left(mapAuthError(e));
    } catch (_) {
      return left(Failure('Something went wrong'));
    }
  }

  /// Signs in an existing user.
  ///
  /// Returns a [User] on success or [Failure] on error.
  Future<Either<Failure, User>> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final User? user = response.user;

      if (user == null) {
        return left(Failure('Sign in failed'));
      }

      return right(user);
    } on AuthException catch (e) {
      return left(mapAuthError(e));
    } catch (_) {
      return left(Failure('Something went wrong'));
    }
  }

  /// Sends a password reset email.
  Future<Either<Failure, bool>> forgotPassword({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return right(true);
    } on AuthException catch (e) {
      return left(mapAuthError(e));
    }
  }

  /// Logs out the currently authenticated user.
  Future<Either<Failure, bool>> logOutUser() async {
    try {
      await _client.auth.signOut();
      return right(true);
    } on AuthException catch (e) {
      return left(mapAuthError(e));
    }
  }

  /// Fetches the current user's profile.
  ///
  /// Attaches a public URL if a profile image exists.
  Future<Either<Failure, UserModel>> fetchUserProfile() async {
    try {
      if (_session == null) {
        return left(Failure('User not signed in'));
      }

      final String userId = _session!.user.id;

      final PostgrestMap response = await _client
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .single();

      final UserModel user = UserModel.fromMap(response);

      return right(_attachPublicUrl(user));
    } on PostgrestException catch (e) {
      return left(Failure(e.message));
    }
  }

  /// Uploads and replaces the user's profile image.
  ///
  /// Deletes any existing image before uploading a new one.
  /// Returns the new storage path on success.
  Future<Either<Failure, String>> updateProfileImage(File image) async {
    try {
      if (_session == null) {
        return left(Failure('User not signed in'));
      }

      final String userId = _session!.user.id;

      final PostgrestMap profile = await _client
          .from('user_profiles')
          .select('image_url')
          .eq('id', userId)
          .single();

      final String? oldPath = profile['image_url'] as String?;

      if (oldPath != null && oldPath.isNotEmpty) {
        await _client.storage.from('userImage').remove(<String>[oldPath]);
      }

      final String id = const Uuid().v4();
      final String extension = image.path.split('.').last;

      final String newPath = 'profile_url/$id.$extension';

      await _client.storage.from('userImage').upload(newPath, image);

      await _client
          .from('user_profiles')
          .update(<String, dynamic>{'image_url': newPath})
          .eq('id', userId);

      return right(newPath);
    } on StorageException catch (e) {
      return left(Failure(e.message));
    } on PostgrestException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error: $e'));
    }
  }

  /// Deletes the user's profile image from storage and database.
  Future<Either<Failure, Unit>> deleteUserProfileImage() async {
    try {
      if (_session == null) {
        return left(Failure('User not signed in'));
      }

      final String userId = _session!.user.id;

      final PostgrestMap profile = await _client
          .from('user_profiles')
          .select('image_url')
          .eq('id', userId)
          .single();

      final String? path = profile['image_url'] as String?;

      if (path == null || path.isEmpty) {
        return left(Failure('No profile image found'));
      }

      await _client.storage.from('userImage').remove(<String>[path]);

      await _client
          .from('user_profiles')
          .update(<String, dynamic>{'image_url': null})
          .eq('id', userId);

      return right(unit);
    } on StorageException catch (e) {
      return left(Failure(e.message));
    } on PostgrestException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error: $e'));
    }
  }

  /// Attaches a public image URL to the given [UserModel].
  UserModel _attachPublicUrl(UserModel user) {
    final String? path = user.imageUrl;

    if (path == null || path.isEmpty) {
      return user;
    }

    final String publicUrl = _client.storage
        .from('userImage')
        .getPublicUrl(path);
    logInfo('Public image url $publicUrl');
    return user.copyWith(imageUrl: publicUrl);
  }

  /// Maps Supabase authentication errors to user-friendly messages.
  Failure mapAuthError(dynamic e) {
    if (e is AuthException) {
      final String message = e.message.toLowerCase();

      final Map<String, String> errorMap = <String, String>{
        'invalid login credentials': 'Invalid email or password',
        'user already registered': 'Email is already registered',
        'email not confirmed': 'Verify your email first',
        'rate limit exceeded': 'Too many attempts',
        'password should be at least': 'Weak password',
      };

      for (final MapEntry<String, String> entry in errorMap.entries) {
        if (message.contains(entry.key)) {
          return Failure(entry.value);
        }
      }

      return Failure(e.message);
    }

    if (e is AuthRetryableFetchException) {
      return Failure('Check your internet connection');
    }

    return Failure('Unexpected auth error');
  }
}
