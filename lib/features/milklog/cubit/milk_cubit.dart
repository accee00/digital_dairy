import 'package:bloc/bloc.dart';
import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:digital_dairy/services/milk_log_service.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'milk_state.dart';

///
class MilkCubit extends Cubit<MilkState> {
  ///
  MilkCubit(this._milkLogService) : super(const MilkInitial());

  final MilkLogService _milkLogService;
  final int _limit = 20;
  bool _isLoading = false;

  Future<void> _load({
    bool refresh = false,
    String? query,
    String? shift,
    bool? sortByQuantity,
  }) async {
    if (_isLoading || (!state.hasMore && !refresh)) {
      return;
    }
    _isLoading = true;
    final String? actualQuery = refresh ? query : (query ?? state.query);
    final String? actualShift = refresh ? shift : (shift ?? state.shift);
    final bool actualSort = sortByQuantity ?? state.sortByQuantity;

    MilkModel? lastItem;
    if (!refresh && state.milkLogList.isNotEmpty) {
      lastItem = state.milkLogList.last;
    }

    emit(
      MilkLoading(
        milkLogList: refresh ? <MilkModel>[] : state.milkLogList,
        hasMore: refresh || state.hasMore,
        query: actualQuery,
        shift: actualShift,
        sortByQuantity: actualSort,
        lastCreatedAt: refresh ? null : lastItem?.createdAt,
        lastId: refresh ? null : lastItem?.id,
      ),
    );

    try {
      final Either<Failure, List<MilkModel>> response = await _milkLogService
          .searchAndGetMilkLog(
            limit: _limit,
            query: actualQuery,
            shift: actualShift,
            sortByQuantity: actualSort,
            lastCreatedAt: refresh ? null : lastItem?.createdAt,
            lastId: refresh ? null : lastItem?.id,
          );

      response.fold(
        (Failure failure) => emit(
          MilkFailure(
            failure.message,
            milkLogList: state.milkLogList,
            query: actualQuery,
            shift: actualShift,
            sortByQuantity: actualSort,
            lastCreatedAt: state.lastCreatedAt,
            lastId: state.lastId,
          ),
        ),
        (List<MilkModel> data) {
          final List<MilkModel> updatedList = refresh
              ? data
              : <MilkModel>[...state.milkLogList, ...data];

          // Update cursor to last item
          final MilkModel? newLastItem = updatedList.isNotEmpty
              ? updatedList.last
              : null;

          emit(
            MilkSuccess(
              milkLogList: updatedList,
              hasMore: data.length == _limit,
              query: actualQuery,
              shift: actualShift,
              sortByQuantity: actualSort,
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

  /// Get milk log with default date range (current month)
  Future<void> getMilkLog({bool refresh = false}) async =>
      _load(refresh: refresh);

  /// Apply filters and refresh the list
  Future<void> applyFilters({
    String? query,
    String? shift,
    bool? sortByQuantity,
  }) async {
    await _load(
      refresh: true,
      query: query,
      shift: shift,
      sortByQuantity: sortByQuantity,
    );
  }

  /// Load more items using cursor pagination
  Future<void> loadMore() async => _load();

  /// Refresh milk log with current filters
  Future<void> refreshMilkLog() async => _load(refresh: true);

  /// Add a new milk log entry
  Future<void> addMilkLog(MilkModel milk) async {
    final Either<Failure, bool> response = await _milkLogService.addMilkEntry(
      milk,
    );
    response.fold(
      (Failure failure) => emit(
        MilkFailure(
          failure.message,
          milkLogList: state.milkLogList,
          query: state.query,
          shift: state.shift,
          sortByQuantity: state.sortByQuantity,
          lastCreatedAt: state.lastCreatedAt,
          lastId: state.lastId,
        ),
      ),
      (bool success) => success ? refreshMilkLog() : null,
    );
  }

  /// Edit an existing milk log entry
  Future<void> editMilk(MilkModel milk) async {
    final Either<Failure, bool> response = await _milkLogService
        .updateMilkEntry(milk);
    response.fold(
      (Failure failure) => emit(
        MilkFailure(
          failure.message,
          milkLogList: state.milkLogList,
          query: state.query,
          shift: state.shift,
          sortByQuantity: state.sortByQuantity,
          lastCreatedAt: state.lastCreatedAt,
          lastId: state.lastId,
        ),
      ),
      (bool success) => success ? refreshMilkLog() : null,
    );
  }
}
