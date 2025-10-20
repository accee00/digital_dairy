part of 'cattle_cubit.dart';

/// Base state for cattle management
abstract class CattleState extends Equatable {
  /// Creates a [CattleState] with a list of cattle
  const CattleState({required this.cattle});

  /// List of cattle
  final List<Cattle> cattle;

  @override
  List<Object> get props => <Object>[cattle];
}

/// Initial state for cattle
class CattleInitial extends CattleState {
  /// Creates initial cattle state with empty list
  const CattleInitial() : super(cattle: const <Cattle>[]);
}

/// Loading state for cattle operations
class CattleLoadingState extends CattleState {
  /// Creates a loading state with current cattle
  const CattleLoadingState({required super.cattle});
}

/// Success state when a cattle is created
class CattleCreatedSuccess extends CattleState {
  /// Creates success state with cattle list and newly created cattle
  const CattleCreatedSuccess({
    required super.cattle,
    required this.newlyCreatedCattle,
  });

  /// Newly created cattle
  final Cattle newlyCreatedCattle;
}

/// Failure state when cattle creation fails
class CattleCreatedFailure extends CattleState {
  /// Creates failure state with cattle list and error message
  const CattleCreatedFailure({required super.cattle, required this.msg});

  /// Error message
  final String msg;
}

/// Loaded state with all cattle
class CattleLoadedState extends CattleState {
  /// Creates loaded state with cattle list
  const CattleLoadedState({required super.cattle});
}

/// Failure state when cattle loading fails
class CattleLoadedFailure extends CattleState {
  /// Creates failure state with cattle list and error message
  const CattleLoadedFailure({required super.cattle, required this.msg});

  /// Error message
  final String msg;
}
