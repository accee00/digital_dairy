import 'package:bloc/bloc.dart';
import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:digital_dairy/services/cattle_service.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'cattle_state.dart';

///
class CattleCubit extends Cubit<CattleState> {
  ///
  CattleCubit(this._cattleService) : super(const CattleInitial());

  final CattleService _cattleService;

  final int _limit = 20;
  bool _isLoading = false;

  Future<void> _load({bool refresh = false, String? search}) async {
    if (_isLoading || (!state.hasMore && !refresh)) {
      return;
    }
    _isLoading = true;

    final String? actualSearch = refresh ? search : (search ?? state.search);

    Cattle? lastItem;
    if (!refresh && state.cattle.isNotEmpty) {
      lastItem = state.cattle.last;
    }

    emit(
      CattleLoadingState(
        cattle: refresh ? <Cattle>[] : state.cattle,
        hasMore: refresh || state.hasMore,
        search: actualSearch,
        lastCreatedAt: refresh ? null : lastItem?.createdAt,
        lastId: refresh ? null : lastItem?.id,
      ),
    );

    try {
      final Either<Failure, List<Cattle>> result = await _cattleService
          .getAndSearchCattle(
            limit: _limit,
            search: actualSearch,
            lastCreatedAt: refresh ? null : lastItem?.createdAt,
            lastId: refresh ? null : lastItem?.id,
          );

      result.fold(
        (Failure failure) => emit(
          CattleLoadedFailure(
            cattle: state.cattle,
            hasMore: state.hasMore,
            msg: failure.message,
            search: actualSearch,
            lastCreatedAt: state.lastCreatedAt,
            lastId: state.lastId,
          ),
        ),
        (List<Cattle> data) {
          final List<Cattle> updatedList = refresh
              ? data
              : <Cattle>[...state.cattle, ...data];

          final Cattle? newLastItem = updatedList.isNotEmpty
              ? updatedList.last
              : null;

          emit(
            CattleLoadedState(
              cattle: updatedList,
              hasMore: data.length == _limit,
              search: actualSearch,
              lastCreatedAt: newLastItem?.createdAt,
              lastId: newLastItem?.id,
            ),
          );
        },
      );
    } finally {
      _isLoading = false;
    }
  }

  Future<void> getCattle({bool refresh = false}) async =>
      _load(refresh: refresh);

  ///
  Future<void> loadMore() async => _load();
  ////
  Future<void> refreshCattle() async => _load(refresh: true);

  ///
  Future<void> applySearch(String? search) async =>
      _load(refresh: true, search: search);

  ///
  Future<void> createCattle(Cattle cattle) async {
    emit(
      CattleLoadingState(
        cattle: state.cattle,
        hasMore: state.hasMore,
        search: state.search,
        lastCreatedAt: state.lastCreatedAt,
        lastId: state.lastId,
      ),
    );

    final Either<Failure, List<Cattle>> result = await _cattleService
        .createCattle(cattle);

    result.fold(
      (Failure failure) => emit(
        CattleCreatedFailure(
          cattle: state.cattle,
          hasMore: state.hasMore,
          msg: failure.message,
          search: state.search,
          lastCreatedAt: state.lastCreatedAt,
          lastId: state.lastId,
        ),
      ),
      (List<Cattle> list) => emit(
        CattleCreatedSuccess(
          cattle: list,
          hasMore: state.hasMore,
          newlyCreatedCattle: list.last,
          search: state.search,
          lastCreatedAt: state.lastCreatedAt,
          lastId: state.lastId,
        ),
      ),
    );
  }

  ///
  Future<void> updateCattle(Cattle cattle) async {
    emit(
      CattleLoadingState(
        cattle: state.cattle,
        hasMore: state.hasMore,
        search: state.search,
        lastCreatedAt: state.lastCreatedAt,
        lastId: state.lastId,
      ),
    );

    final Either<Failure, Cattle> result = await _cattleService.updateCattle(
      cattle,
    );

    result.fold(
      (Failure failure) => emit(
        CattleUpdateFailure(
          cattle: state.cattle,
          hasMore: state.hasMore,
          msg: failure.message,
          search: state.search,
          lastCreatedAt: state.lastCreatedAt,
          lastId: state.lastId,
        ),
      ),
      (Cattle updated) => emit(
        CattleUpdatedSuccess(
          cattle: state.cattle,
          hasMore: state.hasMore,
          updatedCattle: updated,
          search: state.search,
          lastCreatedAt: state.lastCreatedAt,
          lastId: state.lastId,
        ),
      ),
    );
  }

  ///
  Future<void> deleteCattle(String cattleId) async {
    emit(
      CattleLoadingState(
        cattle: state.cattle,
        hasMore: state.hasMore,
        search: state.search,
        lastCreatedAt: state.lastCreatedAt,
        lastId: state.lastId,
      ),
    );

    final Either<Failure, bool> result = await _cattleService.deleteCattle(
      cattleId,
    );

    result.fold(
      (Failure failure) => emit(
        CattleDeleteFailure(
          cattle: state.cattle,
          hasMore: state.hasMore,
          msg: failure.message,
          search: state.search,
          lastCreatedAt: state.lastCreatedAt,
          lastId: state.lastId,
        ),
      ),
      (_) {
        final List<Cattle> updatedList = state.cattle
            .where((Cattle c) => c.id != cattleId)
            .toList();
        emit(
          CattleDeletedSuccess(
            cattle: updatedList,
            hasMore: state.hasMore,
            search: state.search,
            lastCreatedAt: state.lastCreatedAt,
            lastId: state.lastId,
          ),
        );
      },
    );
  }

  /// Milk logs
  Future<void> getMilkLogByCattle({
    required String cattleId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    emit(
      CattleMilkLogLoading(
        cattle: state.cattle,
        hasMore: state.hasMore,
        search: state.search,
        lastCreatedAt: state.lastCreatedAt,
        lastId: state.lastId,
      ),
    );

    final Either<Failure, List<MilkModel>> result = await _cattleService
        .getMilkLogByCattle(
          cattleId: cattleId,
          startDate: startDate,
          endDate: endDate,
        );

    result.fold(
      (Failure f) => emit(
        CattleMilkLogFailure(
          cattle: state.cattle,
          hasMore: state.hasMore,
          msg: f.message,
          search: state.search,
          lastCreatedAt: state.lastCreatedAt,
          lastId: state.lastId,
        ),
      ),
      (List<MilkModel> logs) => emit(
        CattleMilkLogLoaded(
          cattle: state.cattle,
          hasMore: state.hasMore,
          milkLogs: logs,
          search: state.search,
          lastCreatedAt: state.lastCreatedAt,
          lastId: state.lastId,
        ),
      ),
    );
  }
}
