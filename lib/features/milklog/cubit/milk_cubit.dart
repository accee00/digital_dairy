import 'package:bloc/bloc.dart';
import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:digital_dairy/services/milk_log_service.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'milk_state.dart';

class MilkCubit extends Cubit<MilkState> {
  final MilkLogService _milkLogService;
  int _page = 0;
  final int _limit = 10;
  bool _hasMore = true;

  MilkCubit(this._milkLogService) : super(MilkInitial());

  Future<void> getMilkLog({bool refresh = false}) async {
    if (state is MilkLoading) {
      return;
    }

    if (refresh) {
      _page = 0;
      _hasMore = true;
      emit(const MilkLoading(milkLogList: <MilkModel>[]));
    } else {
      emit(MilkLoading(milkLogList: state.milkLogList));
    }

    final Either<Failure, List<MilkModel>> response = await _milkLogService
        .getMilkLog(page: _page, limit: _limit);

    response.fold(
      (Failure failure) {
        emit(MilkFailure(failure.message, milkLogList: state.milkLogList));
      },
      (List<MilkModel> milkLog) {
        if (refresh) {
          emit(
            MilkSuccess(
              milkLogList: milkLog,
              hasMore: milkLog.length == _limit,
            ),
          );
        } else {
          final List<MilkModel> newList = <MilkModel>[
            ...state.milkLogList,
            ...milkLog,
          ];
          if (milkLog.length < _limit) {
            _hasMore = false;
          }
          emit(MilkSuccess(milkLogList: newList, hasMore: _hasMore));
        }
        _page++;
      },
    );
  }

  Future<void> refreshMilkLog() async {
    await getMilkLog(refresh: true);
  }

  Future<void> addMilkLog(MilkModel milk) async {
    final List<MilkModel> currentData = state.milkLogList;

    final Either<Failure, bool> response = await _milkLogService.addMilkEntry(
      milk,
    );

    response.fold(
      (Failure failure) {
        emit(MilkFailure(failure.message, milkLogList: currentData));
      },
      (bool success) {
        if (success) {
          refreshMilkLog();
        } else {
          emit(MilkFailure('Failed to create entry', milkLogList: currentData));
        }
      },
    );
  }

  Future<void> editMilk(MilkModel milk) async {
    final List<MilkModel> currentData = state.milkLogList;

    final Either<Failure, bool> response = await _milkLogService.editMilkEntry(
      milk,
    );

    response.fold(
      (Failure failure) {
        emit(MilkFailure(failure.message, milkLogList: currentData));
      },
      (bool success) {
        if (success) {
          refreshMilkLog();
        } else {
          emit(MilkFailure('Failed to create entry', milkLogList: currentData));
        }
      },
    );
  }
}
