part of 'milk_cubit.dart';

abstract class MilkState extends Equatable {
  const MilkState({this.milkLogList = const <MilkModel>[]});
  final List<MilkModel> milkLogList;

  @override
  List<Object> get props => <Object>[milkLogList];
}

class MilkInitial extends MilkState {
  const MilkInitial() : super(milkLogList: const <MilkModel>[]);
}

class MilkLoading extends MilkState {
  const MilkLoading({required super.milkLogList});
}

class MilkSuccess extends MilkState {
  final bool hasMore;
  const MilkSuccess({required this.hasMore, required super.milkLogList});

  @override
  List<Object> get props => <Object>[milkLogList, hasMore];
}

class MilkFailure extends MilkState {
  MilkFailure(this.message, {required super.milkLogList})
    : dateTime = DateTime.now().microsecondsSinceEpoch;
  final String message;
  final int dateTime;
  @override
  List<Object> get props => <Object>[message, milkLogList, dateTime];
}
