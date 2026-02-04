part of 'profile_cubit.dart';

/// Base class for all profile states.
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initial state.
final class ProfileInitial extends ProfileState {}

/// Loading state.
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

/// Profile image updated successfully.
final class ProfileImageUpdateSuccess extends ProfileState {
  ///
  const ProfileImageUpdateSuccess(this.imagePath);

  ///
  final String imagePath;

  @override
  List<Object?> get props => <Object?>[imagePath];
}

/// Profile image update failed.
final class ProfileImageUpdateFailure extends ProfileState {
  ///
  const ProfileImageUpdateFailure(this.message);

  ///
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// Profile image deleted successfully.
final class ProfileImageDeleteSuccess extends ProfileState {}

/// Profile image delete failed.
final class ProfileImageDeleteFailure extends ProfileState {
  ///
  const ProfileImageDeleteFailure(this.message);

  ///
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
