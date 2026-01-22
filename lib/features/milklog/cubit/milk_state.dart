part of 'milk_cubit.dart';

abstract class MilkState extends Equatable {
  const MilkState({
    this.milkLogList = const <MilkModel>[],
    this.page = 0,
    this.hasMore = true,
    this.query,
    this.shift,
    this.date,
    this.minQuantity,
  });

  final List<MilkModel> milkLogList;
  final int page;
  final bool hasMore;
  final String? query;
  final String? shift;
  final DateTime? date;
  final double? minQuantity;

  @override
  List<Object?> get props => [
    milkLogList,
    page,
    hasMore,
    query,
    shift,
    date,
    minQuantity,
  ];
}

class MilkInitial extends MilkState {
  const MilkInitial() : super();
}

class MilkLoading extends MilkState {
  const MilkLoading({
    required super.milkLogList,
    super.page,
    super.hasMore,
    super.query,
    super.shift,
    super.date,
    super.minQuantity,
  });
}

class MilkSuccess extends MilkState {
  const MilkSuccess({
    required super.milkLogList,
    required super.hasMore,
    required super.page,
    super.query,
    super.shift,
    super.date,
    super.minQuantity,
  });
}

class MilkFailure extends MilkState {
  MilkFailure(
    this.message, {
    required super.milkLogList,
    super.page,
    super.hasMore,
    super.query,
    super.shift,
    super.date,
    super.minQuantity,
  }) : dateTime = DateTime.now().microsecondsSinceEpoch;

  ///
  final String message;

  ///
  final int dateTime;

  @override
  List<Object?> get props => [message, milkLogList, dateTime, page, hasMore];
}
