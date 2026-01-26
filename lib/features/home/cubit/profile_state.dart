part of 'profile_cubit.dart';

///
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => <Object>[];
}

///
final class ProfileInitial extends ProfileState {}

///
class FetchProfileSuccess extends ProfileState {
  ///
  const FetchProfileSuccess(this.user);

  ///
  final UserModel user;
}

///
class FetchProfileFailure extends ProfileState {
  ///
  const FetchProfileFailure(this.msg);

  ///
  final String msg;
}
