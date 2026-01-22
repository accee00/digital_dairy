part of 'milk_cubit.dart';

abstract class MilkState extends Equatable {
  const MilkState({
    this.milkLogList = const <MilkModel>[],
    this.hasMore = true,
    this.query,
    this.shift,
    this.sortByQuantity = false,
    this.lastCreatedAt,
    this.lastId,
  });

  final List<MilkModel> milkLogList;
  final bool hasMore;
  final String? query;
  final String? shift;
  final bool sortByQuantity;
  final DateTime? lastCreatedAt;
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

class MilkInitial extends MilkState {
  const MilkInitial() : super();
}

class MilkLoading extends MilkState {
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

class MilkSuccess extends MilkState {
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

class MilkFailure extends MilkState {
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

  final String message;
  final int dateTime;

  @override
  List<Object?> get props => [...super.props, message, dateTime];
}
