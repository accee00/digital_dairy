part of 'milk_cubit.dart';

sealed class MilkState extends Equatable {
  const MilkState();

  @override
  List<Object> get props => [];
}

final class MilkInitial extends MilkState {}

class MilkCreatedFailure extends MilkState {
  final String msg;
  MilkCreatedFailure(this.msg);
}

class MilkCreatedSuccess extends MilkState {}
