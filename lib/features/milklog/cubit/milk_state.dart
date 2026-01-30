part of 'milk_cubit.dart';

/// Base state for all milk-related states.
abstract class MilkState extends Equatable {
  /// Creates a [MilkState].
  const MilkState({
    this.milkLogList = const <MilkModel>[],
    this.hasMore = true,
    this.query,
    this.shift,
    this.sortByQuantity = false,
    this.lastCreatedAt,
    this.lastId,
  });

  /// List of milk log entries.
  final List<MilkModel> milkLogList;

  /// Whether more data can be loaded (pagination).
  final bool hasMore;

  /// Search query.
  final String? query;

  /// Shift filter (morning/evening).
  final String? shift;

  /// Whether to sort by quantity.
  final bool sortByQuantity;

  /// Cursor field for pagination - last created at timestamp.
  final DateTime? lastCreatedAt;

  /// Cursor field for pagination - last item ID.
  final String? lastId;

  @override
  List<Object?> get props => <Object?>[
    milkLogList,
    hasMore,
    query,
    shift,
    sortByQuantity,
    lastCreatedAt,
    lastId,
  ];
}

/// Initial state before any milk data is loaded.
class MilkInitial extends MilkState {
  /// Creates a [MilkInitial] state.
  const MilkInitial() : super();
}

/// Loading state while fetching milk logs.
class MilkLoading extends MilkState {
  /// Creates a [MilkLoading] state.
  const MilkLoading({
    required super.milkLogList,
    super.hasMore,
    super.query,
    super.shift,
    super.sortByQuantity,
    super.lastCreatedAt,
    super.lastId,
  });
}

/// State when milk logs are successfully loaded.
class MilkSuccess extends MilkState {
  /// Creates a [MilkSuccess] state.
  const MilkSuccess({
    required super.milkLogList,
    required super.hasMore,
    super.query,
    super.shift,
    super.sortByQuantity,
    super.lastCreatedAt,
    super.lastId,
  });
}

/// State when loading milk logs fails.
class MilkFailure extends MilkState {
  /// Creates a [MilkFailure] state with error [message].
  MilkFailure(
    this.message, {
    required super.milkLogList,
    super.hasMore,
    super.query,
    super.shift,
    super.sortByQuantity,
    super.lastCreatedAt,
    super.lastId,
  }) : dateTime = DateTime.now().microsecondsSinceEpoch;

  /// The error message.
  final String message;

  /// Timestamp to ensure unique state for equatable.
  final int dateTime;

  @override
  List<Object?> get props => <Object?>[...super.props, message, dateTime];
}
