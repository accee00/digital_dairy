import 'package:bloc/bloc.dart';
import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/features/auth/model/user.dart';
import 'package:digital_dairy/services/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'profile_state.dart';

///
class ProfileCubit extends Cubit<ProfileState> {
  ///
  ProfileCubit(this.authService) : super(ProfileInitial());

  ///
  final AuthService authService;

  ///
  Future<void> fetchProfile() async {
    final Either<Failure, UserModel> response = await authService
        .fetchUserProfile();

    response.fold(
      (Failure failure) => emit(FetchProfileFailure(failure.message)),
      (UserModel data) => emit(FetchProfileSuccess(data)),
    );
  }
}
