import 'package:bloc/bloc.dart';
import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/features/home/model/analytics_model.dart';
import 'package:digital_dairy/services/analytics_service.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'analytics_state.dart';

///
class AnalyticsCubit extends Cubit<AnalyticsState> {
  ///
  AnalyticsCubit(this.analyticsService) : super(AnalyticsInitial());

  ///
  final AnalyticsService analyticsService;

  ///
  Future<void> fetchAnalytics() async {
    emit(AnalyticsLoading());

    final Either<Failure, AnalyticsModel> result = await analyticsService
        .getDashboardAnalytics();

    result.fold(
      (Failure failure) => emit(AnalyticsError(failure.message)),
      (AnalyticsModel analytics) => emit(AnalyticsLoaded(analytics)),
    );
  }

  ///
  Future<void> refreshAnalytics() async {
    await fetchAnalytics();
  }

  ///
  void clear() {
    emit(AnalyticsInitial());
  }
}
