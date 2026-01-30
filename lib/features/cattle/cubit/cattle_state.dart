part of 'cattle_cubit.dart';

/// Base state for all cattle-related states.
abstract class CattleState extends Equatable {
  /// Creates a [CattleState].
  const CattleState({
    required this.cattle,
    required this.hasMore,
    this.search,
    this.lastCreatedAt,
    this.lastId,
  });

  /// Current list of cattle.
  final List<Cattle> cattle;

  /// Whether more data can be loaded (pagination).
  final bool hasMore;

  /// Search query.
  final String? search;

  /// Cursor field for pagination - last created at timestamp.
  final DateTime? lastCreatedAt;

  /// Cursor field for pagination - last item ID.
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

/// Initial state before any cattle data is loaded.
class CattleInitial extends CattleState {
  /// Creates a [CattleInitial] state.
  const CattleInitial() : super(cattle: const <Cattle>[], hasMore: true);
}

/// Loading state (used for list load & CRUD operations).
class CattleLoadingState extends CattleState {
  /// Creates a [CattleLoadingState].
  const CattleLoadingState({
    required super.cattle,
    required super.hasMore,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });
}

/// State when cattle list is successfully loaded.
class CattleLoadedState extends CattleState {
  /// Creates a [CattleLoadedState].
  const CattleLoadedState({
    required super.cattle,
    required super.hasMore,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });
}

/// State when cattle loading fails.
class CattleLoadedFailure extends CattleState {
  /// Creates a [CattleLoadedFailure] with error [msg].
  const CattleLoadedFailure({
    required super.cattle,
    required super.hasMore,
    required this.msg,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  /// The error message.
  final String msg;

  @override
  List<Object?> get props => <Object?>[msg, ...super.props];
}

/// State when cattle creation succeeds.
class CattleCreatedSuccess extends CattleState {
  /// Creates a [CattleCreatedSuccess] with [newlyCreatedCattle].
  const CattleCreatedSuccess({
    required super.cattle,
    required super.hasMore,
    required this.newlyCreatedCattle,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  /// The newly created cattle.
  final Cattle newlyCreatedCattle;

  @override
  List<Object?> get props => <Object?>[newlyCreatedCattle, ...super.props];
}

/// State when cattle creation fails.
class CattleCreatedFailure extends CattleState {
  /// Creates a [CattleCreatedFailure] with error [msg].
  const CattleCreatedFailure({
    required super.cattle,
    required super.hasMore,
    required this.msg,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  /// The error message.
  final String msg;

  @override
  List<Object?> get props => <Object?>[msg, ...super.props];
}

/// State when cattle update succeeds.
class CattleUpdatedSuccess extends CattleState {
  /// Creates a [CattleUpdatedSuccess] with [updatedCattle].
  const CattleUpdatedSuccess({
    required super.cattle,
    required super.hasMore,
    required this.updatedCattle,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  /// The updated cattle.
  final Cattle updatedCattle;

  @override
  List<Object?> get props => <Object?>[updatedCattle, ...super.props];
}

/// State when cattle update fails.
class CattleUpdateFailure extends CattleState {
  /// Creates a [CattleUpdateFailure] with error [msg].
  const CattleUpdateFailure({
    required super.cattle,
    required super.hasMore,
    required this.msg,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  /// The error message.
  final String msg;

  @override
  List<Object?> get props => <Object?>[msg, ...super.props];
}

/// State when cattle deletion succeeds.
class CattleDeletedSuccess extends CattleState {
  /// Creates a [CattleDeletedSuccess].
  const CattleDeletedSuccess({
    required super.cattle,
    required super.hasMore,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });
}

/// State when cattle deletion fails.
class CattleDeleteFailure extends CattleState {
  /// Creates a [CattleDeleteFailure] with error [msg].
  const CattleDeleteFailure({
    required super.cattle,
    required super.hasMore,
    required this.msg,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  /// The error message.
  final String msg;

  @override
  List<Object?> get props => <Object?>[msg, ...super.props];
}

/// Loading state while fetching milk logs.
class CattleMilkLogLoading extends CattleState {
  /// Creates a [CattleMilkLogLoading].
  const CattleMilkLogLoading({
    required super.cattle,
    required super.hasMore,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });
}

/// State when milk logs are successfully fetched.
class CattleMilkLogLoaded extends CattleState {
  /// Creates a [CattleMilkLogLoaded] with [milkLogs].
  const CattleMilkLogLoaded({
    required super.cattle,
    required super.hasMore,
    required this.milkLogs,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  /// The list of milk logs for the cattle.
  final List<MilkModel> milkLogs;

  @override
  List<Object?> get props => <Object?>[milkLogs, ...super.props];
}

/// State when fetching milk logs fails.
class CattleMilkLogFailure extends CattleState {
  /// Creates a [CattleMilkLogFailure] with error [msg].
  const CattleMilkLogFailure({
    required super.cattle,
    required super.hasMore,
    required this.msg,
    super.search,
    super.lastCreatedAt,
    super.lastId,
  });

  /// The error message.
  final String msg;

  @override
  List<Object?> get props => <Object?>[msg, ...super.props];
}
