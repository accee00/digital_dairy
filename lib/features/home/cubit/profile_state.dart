part of 'profile_cubit.dart';

/// Base class for all profile states.
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initial state.
final class ProfileInitial extends ProfileState {}

/// Loading state
final class ProfileLoading extends ProfileState {}

/// Profile fetched successfully.
final class FetchProfileSuccess extends ProfileState {
  ///
  const FetchProfileSuccess(this.user);

  ///
  final UserModel user;

  @override
  List<Object?> get props => <Object?>[user];
}

/// Profile fetch failed.
final class FetchProfileFailure extends ProfileState {
  ///
  const FetchProfileFailure(this.message);

  ///
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// Profile image is being uploaded.
final class ProfileImageUploading extends ProfileState {
  ///
  const ProfileImageUploading(this.user);

  ///
  final UserModel user;

  @override
  List<Object?> get props => <Object?>[user];
}

/// Profile image updated successfully.
final class ProfileImageUpdateSuccess extends ProfileState {
  ///
  const ProfileImageUpdateSuccess(this.imagePath, this.user);

  ///
  final String imagePath;

  ///
  final UserModel user;

  @override
  List<Object?> get props => <Object?>[imagePath, user];
}

/// Profile image update failed.
final class ProfileImageUpdateFailure extends ProfileState {
  ///
  const ProfileImageUpdateFailure(this.message, this.user);

  ///
  final String message;

  ///
  final UserModel user;

  @override
  List<Object?> get props => <Object?>[message, user];
}

/// Profile image is being deleted.
final class ProfileImageDeleting extends ProfileState {
  ///
  const ProfileImageDeleting(this.user);

  ///
  final UserModel user;

  @override
  List<Object?> get props => <Object?>[user];
}

/// Profile image deleted successfully.
final class ProfileImageDeleteSuccess extends ProfileState {
  ///
  const ProfileImageDeleteSuccess(this.user);

  ///
  final UserModel user;

  @override
  List<Object?> get props => <Object?>[user];
}

/// Profile image delete failed.
final class ProfileImageDeleteFailure extends ProfileState {
  ///
  const ProfileImageDeleteFailure(this.message, this.user);

  ///
  final String message;

  ///
  final UserModel user;

  @override
  List<Object?> get props => <Object?>[message, user];
}
