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
    DateTime? date,
    double? minQuantity,
    bool isSearching = false,
  }) async {
    if (_isLoading) {
      return;
    }
    if (!state.hasMore && !refresh) {
      return;
    }

    _isLoading = true;

    final int currentPage = refresh ? 0 : state.page;

    emit(
      MilkLoading(
        milkLogList: refresh ? <MilkModel>[] : state.milkLogList,
        page: currentPage,
        hasMore: refresh || state.hasMore,
        query: query,
        shift: shift,
        date: date,
        minQuantity: minQuantity,
      ),
    );

    try {
      final Either<Failure, List<MilkModel>> response = isSearching
          ? await _milkLogService.searchMilk(
              page: currentPage,
              limit: _limit,
              query: query,
              shift: shift,
              date: date,
              minQuantity: minQuantity,
            )
          : await _milkLogService.getMilkLog(page: currentPage, limit: _limit);

      // ignore: cascade_invocations
      response.fold(
        (Failure failure) => emit(
          MilkFailure(
            failure.message,
            milkLogList: state.milkLogList,
            page: state.page,
            hasMore: state.hasMore,
          ),
        ),
        (List<MilkModel> data) {
          final List<MilkModel> updatedList = refresh
              ? data
              : <MilkModel>[...state.milkLogList, ...data];
          final bool hasMore = data.length == _limit;

          emit(
            MilkSuccess(
              milkLogList: updatedList,
              hasMore: hasMore,
              page: currentPage + 1,
              query: query,
              shift: shift,
              date: date,
              minQuantity: minQuantity,
            ),
          );
        },
      );
    } finally {
      _isLoading = false;
    }
  }

  ///
  Future<void> getMilkLog({bool refresh = false}) async {
    await _load(refresh: refresh);
  }

  ///
  Future<void> searchMilk({
    String? query,
    String? shift,
    DateTime? date,
    double? minQuantity,
    bool loadMore = false,
  }) async {
    await _load(
      refresh: !loadMore,
      query: query,
      shift: shift,
      date: date,
      minQuantity: minQuantity,
      isSearching: true,
    );
  }

  ///
  Future<void> refreshMilkLog() async {
    final bool isSearching = state.query != null || state.date != null;
    await _load(
      refresh: true,
      query: state.query,
      shift: state.shift,
      date: state.date,
      minQuantity: state.minQuantity,
      isSearching: isSearching,
    );
  }

  ///
  Future<void> addMilkLog(MilkModel milk) async {
    final Either<Failure, bool> response = await _milkLogService.addMilkEntry(
      milk,
    );

    await response.fold(
      (Failure failure) async =>
          emit(MilkFailure(failure.message, milkLogList: state.milkLogList)),
      (bool success) async {
        if (success) {
          await refreshMilkLog();
        } else {
          emit(
            MilkFailure(
              'Failed to create entry',
              milkLogList: state.milkLogList,
            ),
          );
        }
      },
    );
  }

  ///
  Future<void> editMilk(MilkModel milk) async {
    final Either<Failure, bool> response = await _milkLogService
        .updateMilkEntry(milk);

    await response.fold(
      (Failure failure) async =>
          emit(MilkFailure(failure.message, milkLogList: state.milkLogList)),
      (bool success) async {
        if (success) {
          await refreshMilkLog();
        } else {
          emit(
            MilkFailure(
              'Failed to update entry',
              milkLogList: state.milkLogList,
            ),
          );
        }
      },
    );
  }

  ///
  bool get isLoading => _isLoading;
}
