part of 'cattle_cubit.dart';

/// Base state for all cattle-related states
abstract class CattleState extends Equatable {
  const CattleState({required this.cattle});

  /// Current list of cattle
  final List<Cattle> cattle;

  @override
  List<Object> get props => <Object>[cattle];
}

/// Initial state when cubit is first created
class CattleInitial extends CattleState {
  const CattleInitial() : super(cattle: const <Cattle>[]);
}

/// Loading state for any cattle operation
class CattleLoadingState extends CattleState {
  const CattleLoadingState({required super.cattle});
}

/// State when cattle creation succeeds
class CattleCreatedSuccess extends CattleState {
  const CattleCreatedSuccess({
    required super.cattle,
    required this.newlyCreatedCattle,
  });

  /// The newly added cattle
  final Cattle newlyCreatedCattle;
}

/// State when cattle creation fails
class CattleCreatedFailure extends CattleState {
  const CattleCreatedFailure({required super.cattle, required this.msg});

  /// Error message
  final String msg;
}

/// State when cattle update succeeds
class CattleUpdatedSuccess extends CattleState {
  final Cattle updatedCattle;

  const CattleUpdatedSuccess({
    required super.cattle,
    required this.updatedCattle,
  });
}

/// State when cattle update fails
class CattleUpdateFailure extends CattleState {
  const CattleUpdateFailure({required super.cattle, required this.msg});

  /// Error message
  final String msg;
}

/// State when cattle deletion succeeds
class CattleDeletedSuccess extends CattleState {
  const CattleDeletedSuccess({required super.cattle});
}

/// State when cattle deletion fails
class CattleDeleteFailure extends CattleState {
  const CattleDeleteFailure({required super.cattle, required this.msg});

  /// Error message
  final String msg;
}

/// State when cattle list is successfully loaded
class CattleLoadedState extends CattleState {
  const CattleLoadedState({required super.cattle});
}

/// State when cattle loading fails
class CattleLoadedFailure extends CattleState {
  const CattleLoadedFailure({required super.cattle, required this.msg});

  /// Error message
  final String msg;
}

/// Loading state while fetching milk logs
class CattleMilkLogLoading extends CattleState {
  const CattleMilkLogLoading({required super.cattle});
}

/// State when milk logs are successfully fetched
class CattleMilkLogLoaded extends CattleState {
  const CattleMilkLogLoaded({required super.cattle, required this.milkLogs});

  /// List of milk logs for selected cattle
  final List<MilkModel> milkLogs;

  @override
  List<Object> get props => <Object>[cattle, milkLogs];
}

/// State when fetching milk logs fails
class CattleMilkLogFailure extends CattleState {
  const CattleMilkLogFailure({required super.cattle, required this.msg});

  /// Error message
  final String msg;
}
