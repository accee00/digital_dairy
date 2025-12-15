part of 'sales_cubit.dart';

abstract class SalesState extends Equatable {
  const SalesState({this.buyers = const <Buyer>[]});

  final List<Buyer> buyers;

  @override
  List<Object> get props => <Object>[buyers];
}

class SalesInitial extends SalesState {
  const SalesInitial() : super(buyers: const <Buyer>[]);

  @override
  List<Object> get props => <Object>[buyers];
}

class SalesLoading extends SalesState {
  const SalesLoading({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

// Buyer Add States
class BuyerAddedSuccess extends SalesState {
  const BuyerAddedSuccess({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

class BuyerAddedFailure extends SalesState {
  const BuyerAddedFailure({required this.errorMsg, super.buyers});

  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}

// Buyer Update States
class BuyerUpdateSuccess extends SalesState {
  const BuyerUpdateSuccess({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

class BuyerUpdateFailure extends SalesState {
  const BuyerUpdateFailure({required this.errorMsg, super.buyers});

  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}

// Buyer Delete States
class BuyerDeleteSuccess extends SalesState {
  const BuyerDeleteSuccess({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

class BuyerDeleteFailure extends SalesState {
  const BuyerDeleteFailure({required this.errorMsg, super.buyers});

  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}

// Get Buyer States
class GetBuyerSuccess extends SalesState {
  const GetBuyerSuccess({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

class GetBuyerFailure extends SalesState {
  const GetBuyerFailure({required this.errorMsg, super.buyers});

  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}

// Sales Add States
class SaleAddSuccess extends SalesState {
  const SaleAddSuccess({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

class SalesAddFailure extends SalesState {
  const SalesAddFailure({required this.errorMsg, super.buyers});

  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}

// Sales Update States
class SalesUpdateSuccess extends SalesState {
  const SalesUpdateSuccess({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

class SalesUpdateFailure extends SalesState {
  const SalesUpdateFailure({required this.errorMsg, super.buyers});

  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}

// Get Sales States
class GetSalesSuccessState extends SalesState {
  GetSalesSuccessState(this.sales, {super.buyers});
  final List<MilkSale> sales;

  @override
  List<Object> get props => <Object>[buyers, sales];
}

class GetSalesFailureState extends SalesState {
  const GetSalesFailureState({required this.errorMsg, super.buyers});

  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}
