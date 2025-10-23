part of 'sales_cubit.dart';

abstract class SalesState extends Equatable {
  const SalesState({
    this.milkSales = const <MilkSale>[],
    this.buyers = const <Buyer>[],
  });

  final List<MilkSale> milkSales;
  final List<Buyer> buyers;

  @override
  List<Object> get props => <Object>[milkSales, buyers];
}

class SalesInitial extends SalesState {
  SalesInitial()
    : super(milkSales: const <MilkSale>[], buyers: const <Buyer>[]);

  @override
  List<Object> get props => <Object>[milkSales, buyers];
}

class SalesLoading extends SalesState {
  const SalesLoading({super.milkSales, super.buyers});

  @override
  List<Object> get props => <Object>[milkSales, buyers];
}

class BuyerAddedSuccess extends SalesState {
  const BuyerAddedSuccess({super.milkSales, super.buyers});

  @override
  List<Object> get props => <Object>[milkSales, buyers];
}

class BuyerAddedFailure extends SalesState {
  const BuyerAddedFailure({
    super.milkSales,
    super.buyers,
    required this.errorMsg,
  });

  final String errorMsg;

  @override
  List<Object> get props => <Object>[milkSales, buyers, errorMsg];
}

class GetBuyerSuccess extends SalesState {
  const GetBuyerSuccess({super.milkSales, super.buyers});

  @override
  List<Object> get props => <Object>[milkSales, buyers];
}

class GetBuyerFailure extends SalesState {
  const GetBuyerFailure({
    super.milkSales,
    super.buyers,
    required this.errorMsg,
  });

  final String errorMsg;

  @override
  List<Object> get props => <Object>[milkSales, buyers, errorMsg];
}
