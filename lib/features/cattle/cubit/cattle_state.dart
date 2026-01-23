part of 'cattle_cubit.dart';

/// Base state for all cattle-related states
abstract class CattleState extends Equatable {
  const CattleState({
    required this.cattle,
    required this.hasMore,
    this.search,
    this.lastCreatedAt,
    this.lastId,
  });

  /// Current list of cattle
  final List<Cattle> cattle;

  /// Whether more data can be loaded (pagination)
  final bool hasMore;

  /// Search query
  final String? search;

  /// Cursor fields
  final DateTime? lastCreatedAt;
  final String? lastId;

  @override
  List<Object?> get props => <Object?>[
    cattle,
    hasMore,
    search,
    lastCreatedAt,
    lastId,
  ];
}

/// Initial state
class CattleInitial extends CattleState {
  const CattleInitial() : super(cattle: const <Cattle>[], hasMore: true);
}

/// Loading state (used for list load & CRUD)
class CattleLoadingState extends CattleState {
  const CattleLoadingState({
    required super.cattle,
    required super.hasMore,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });
}

/// State when cattle list is successfully loaded
class CattleLoadedState extends CattleState {
  const CattleLoadedState({
    required super.cattle,
    required super.hasMore,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });
}

/// State when cattle loading fails
class CattleLoadedFailure extends CattleState {
  const CattleLoadedFailure({
    required super.cattle,
    required super.hasMore,
    required this.msg,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  final String msg;

  @override
  List<Object?> get props => <Object?>[msg, ...super.props];
}

/// State when cattle creation succeeds
class CattleCreatedSuccess extends CattleState {
  const CattleCreatedSuccess({
    required super.cattle,
    required super.hasMore,
    required this.newlyCreatedCattle,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  final Cattle newlyCreatedCattle;

  @override
  List<Object?> get props => <Object?>[newlyCreatedCattle, ...super.props];
}

/// State when cattle creation fails
class CattleCreatedFailure extends CattleState {
  const CattleCreatedFailure({
    required super.cattle,
    required super.hasMore,
    required this.msg,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  final String msg;

  @override
  List<Object?> get props => <Object?>[msg, ...super.props];
}

/// State when cattle update succeeds
class CattleUpdatedSuccess extends CattleState {
  const CattleUpdatedSuccess({
    required super.cattle,
    required super.hasMore,
    required this.updatedCattle,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  final Cattle updatedCattle;

  @override
  List<Object?> get props => <Object?>[updatedCattle, ...super.props];
}

/// State when cattle update fails
class CattleUpdateFailure extends CattleState {
  const CattleUpdateFailure({
    required super.cattle,
    required super.hasMore,
    required this.msg,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  final String msg;

  @override
  List<Object?> get props => <Object?>[msg, ...super.props];
}

/// State when cattle deletion succeeds
class CattleDeletedSuccess extends CattleState {
  const CattleDeletedSuccess({
    required super.cattle,
    required super.hasMore,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });
}

/// State when cattle deletion fails
class CattleDeleteFailure extends CattleState {
  const CattleDeleteFailure({
    required super.cattle,
    required super.hasMore,
    required this.msg,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  final String msg;

  @override
  List<Object?> get props => <Object?>[msg, ...super.props];
}

/// Loading state while fetching milk logs
class CattleMilkLogLoading extends CattleState {
  const CattleMilkLogLoading({
    required super.cattle,
    required super.hasMore,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });
}

/// State when milk logs are successfully fetched
class CattleMilkLogLoaded extends CattleState {
  const CattleMilkLogLoaded({
    required super.cattle,
    required super.hasMore,
    required this.milkLogs,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  final List<MilkModel> milkLogs;

  @override
  List<Object?> get props => <Object?>[milkLogs, ...super.props];
}

/// State when fetching milk logs fails
class CattleMilkLogFailure extends CattleState {
  const CattleMilkLogFailure({
    required super.cattle,
    required super.hasMore,
    required this.msg,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  final String msg;

  @override
  List<Object?> get props => <Object?>[msg, ...super.props];
}
