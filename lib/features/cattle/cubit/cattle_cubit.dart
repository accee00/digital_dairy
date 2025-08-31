import 'package:bloc/bloc.dart';
import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:digital_dairy/services/cattle_service.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'cattle_state.dart';

///
class CattleCubit extends Cubit<CattleState> {
  ///
  CattleCubit(this.cattleService) : super(const CattleInitial());

  ///
  final CattleService cattleService;

  ////
  Future<void> createCattle(Cattle cattle) async {
    emit(CattleLoadingState(cattle: state.cattle));

    final Either<Failure, List<Cattle>> result = await cattleService
        .createCattle(cattle);

    result.fold(
      (Failure failure) {
        emit(CattleCreatedFailure(cattle: state.cattle, msg: failure.message));
      },
      (List<Cattle> cattle) {
        final Cattle newlyCreated = cattle.last;
        emit(
          CattleCreatedSuccess(
            cattle: cattle,
            newlyCreatedCattle: newlyCreated,
          ),
        );
      },
    );
  }

  ///
  Future<void> getAllCattle() async {
    emit(CattleLoadingState(cattle: state.cattle));
    final Either<Failure, List<Cattle>> result = await cattleService
        .getAllCattle();
    result.fold(
      (Failure failure) =>
          emit(CattleLoadedFailure(cattle: state.cattle, msg: failure.message)),
      (List<Cattle> result) => emit(CattleLoadedState(cattle: result)),
    );
  }
}
