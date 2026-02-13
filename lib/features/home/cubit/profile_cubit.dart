import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/features/auth/model/user.dart';
import 'package:digital_dairy/services/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'profile_state.dart';

/// Manages user profile state.
class ProfileCubit extends Cubit<ProfileState> {
  /// Creates a [ProfileCubit].
  ProfileCubit(this._authService) : super(ProfileInitial());

  /// Auth service dependency.
  final AuthService _authService;

  /// Fetches the current user's profile.
  Future<void> fetchProfile() async {
    emit(ProfileLoading());

    final Either<Failure, UserModel> response = await _authService
        .fetchUserProfile();

    response.fold(
      (Failure failure) {
        emit(FetchProfileFailure(failure.message));
      },
      (UserModel user) {
        emit(FetchProfileSuccess(user));
      },
    );
  }

  /// Uploads and updates the user's profile image.
  Future<void> updateProfileImage({required File image}) async {
    final ProfileState currentState = state;
    if (currentState is! FetchProfileSuccess) {
      return;
    }

    emit(ProfileImageUploading(currentState.user));

    final Either<Failure, String> response = await _authService
        .updateProfileImage(image);

    response.fold(
      (Failure failure) {
        emit(ProfileImageUpdateFailure(failure.message, currentState.user));
      },
      (String path) {
        emit(ProfileImageUpdateSuccess(path, currentState.user));

        fetchProfile();
      },
    );
  }

  /// Deletes the user's profile image.
  Future<void> deleteProfileImage() async {
    final ProfileState currentState = state;
    if (currentState is! FetchProfileSuccess) {
      return;
    }

    emit(ProfileImageDeleting(currentState.user));

    final Either<Failure, Unit> response = await _authService
        .deleteUserProfileImage();

    response.fold(
      (Failure failure) {
        emit(ProfileImageDeleteFailure(failure.message, currentState.user));
      },
      (_) {
        emit(ProfileImageDeleteSuccess(currentState.user));
        fetchProfile();
      },
    );
  }

  ///
  void clear() {
    emit(ProfileInitial());
  }
}
