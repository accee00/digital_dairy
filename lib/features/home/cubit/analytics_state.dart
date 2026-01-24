part of 'analytics_cubit.dart';

///
sealed class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object> get props => <Object>[];
}

///
final class AnalyticsInitial extends AnalyticsState {}

///
final class AnalyticsLoading extends AnalyticsState {}

///
final class AnalyticsLoaded extends AnalyticsState {
  ///
  const AnalyticsLoaded(this.analytics);

  ///
  final AnalyticsModel analytics;

  @override
  List<Object> get props => <Object>[analytics];
}

///
final class AnalyticsError extends AnalyticsState {
  ///
  const AnalyticsError(this.message);

  ///
  final String message;

  @override
  List<Object> get props => <Object>[message];
}
