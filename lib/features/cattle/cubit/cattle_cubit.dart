import 'package:bloc/bloc.dart';
import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:digital_dairy/services/cattle_service.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'cattle_state.dart';

/// Cubit responsible for handling all cattle-related actions
/// such as create, update, delete, fetch cattle and milk logs
class CattleCubit extends Cubit<CattleState> {
  /// Injects [CattleService]
  CattleCubit(this.cattleService) : super(const CattleInitial());

  /// Service layer for cattle APIs
  final CattleService cattleService;

  /// Creates a new cattle entry
  Future<void> createCattle(Cattle cattle) async {
    emit(CattleLoadingState(cattle: state.cattle));

    final Either<Failure, List<Cattle>> result = await cattleService
        .createCattle(cattle);

    result.fold(
      /// On failure, emit error state with message
      (Failure failure) {
        emit(CattleCreatedFailure(cattle: state.cattle, msg: failure.message));
      },

      /// On success, emit created state with updated list
      (List<Cattle> cattleList) {
        emit(
          CattleCreatedSuccess(
            cattle: cattleList,
            newlyCreatedCattle: cattleList.last,
          ),
        );
      },
    );
  }

  /// Updates an existing cattle
  Future<void> updateCattle(Cattle cattle) async {
    emit(CattleLoadingState(cattle: state.cattle));

    final Either<Failure, List<Cattle>> result = await cattleService
        .updateCattle(cattle);

    result.fold(
      /// Emit failure if update fails
      (Failure failure) {
        emit(CattleUpdateFailure(cattle: state.cattle, msg: failure.message));
      },

      /// Emit success with updated cattle list
      (List<Cattle> updatedList) {
        emit(CattleUpdatedSuccess(cattle: updatedList));
      },
    );
  }

  /// Deletes a cattle using its ID
  Future<void> deleteCattle(String cattleId) async {
    emit(CattleLoadingState(cattle: state.cattle));

    final Either<Failure, bool> result = await cattleService.deleteCattle(
      cattleId,
    );

    result.fold(
      /// Emit failure state if deletion fails
      (Failure failure) {
        emit(CattleDeleteFailure(cattle: state.cattle, msg: failure.message));
      },

      /// Remove deleted cattle locally and emit success
      (_) {
        final List<Cattle> updatedList = state.cattle
            .where((Cattle c) => c.id != cattleId)
            .toList();

        emit(CattleDeletedSuccess(cattle: updatedList));
      },
    );
  }

  /// Fetches all cattle for the logged-in user
  Future<void> getAllCattle() async {
    emit(CattleLoadingState(cattle: state.cattle));

    final Either<Failure, List<Cattle>> result = await cattleService
        .getAllCattle();

    result.fold(
      /// Emit failure if API fails
      (Failure failure) =>
          emit(CattleLoadedFailure(cattle: state.cattle, msg: failure.message)),

      /// Emit loaded state with cattle list
      (List<Cattle> cattleList) => emit(CattleLoadedState(cattle: cattleList)),
    );
  }

  /// Fetches milk logs for a specific cattle within a date range
  Future<void> getMilkLogByCattle({
    required String cattleId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    emit(CattleMilkLogLoading(cattle: state.cattle));

    final Either<Failure, List<MilkModel>> result = await cattleService
        .getMilkLogByCattle(
          cattleId: cattleId,
          startDate: startDate,
          endDate: endDate,
        );

    result.fold(
      /// Emit failure state if fetching fails
      (Failure failure) => emit(
        CattleMilkLogFailure(cattle: state.cattle, msg: failure.message),
      ),

      /// Emit loaded state with milk logs
      (List<MilkModel> logs) =>
          emit(CattleMilkLogLoaded(cattle: state.cattle, milkLogs: logs)),
    );
  }
}
