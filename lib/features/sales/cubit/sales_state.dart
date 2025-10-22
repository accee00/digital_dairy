part of 'sales_cubit.dart';

abstract class SalesState extends Equatable {
  const SalesState({this.milkSales = const <MilkSale>[]});
  final List<MilkSale> milkSales;
  @override
  List<Object> get props => <Object>[milkSales];
}

class SalesInitial extends SalesState {
  SalesInitial() : super(milkSales: <MilkSale>[]);
  @override
  List<Object> get props => <Object>[milkSales];
}

class SalesLoading extends SalesState {
  SalesLoading({super.milkSales});
  @override
  List<Object> get props => <Object>[milkSales];
}

class BuyerAddedSuccess extends SalesState {
  BuyerAddedSuccess({super.milkSales});
  @override
  List<Object> get props => <Object>[milkSales];
}

class BuyerAddedFailure extends SalesState {
  BuyerAddedFailure({super.milkSales, required this.errorMsg});
  final String errorMsg;
  @override
  List<Object> get props => <Object>[milkSales, errorMsg];
}
