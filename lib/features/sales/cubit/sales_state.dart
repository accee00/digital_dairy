part of 'sales_cubit.dart';

/// Base state for all sales-related states.
abstract class SalesState extends Equatable {
  /// Creates a [SalesState].
  const SalesState({this.buyers = const <Buyer>[]});

  /// List of buyers.
  final List<Buyer> buyers;

  @override
  List<Object> get props => <Object>[buyers];
}

/// Initial state before any sales data is loaded.
class SalesInitial extends SalesState {
  /// Creates a [SalesInitial] state.
  const SalesInitial() : super(buyers: const <Buyer>[]);

  @override
  List<Object> get props => <Object>[buyers];
}

/// Loading state while fetching sales data.
class SalesLoading extends SalesState {
  /// Creates a [SalesLoading] state.
  const SalesLoading({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

/// State when a buyer is successfully added.
class BuyerAddedSuccess extends SalesState {
  /// Creates a [BuyerAddedSuccess] state.
  const BuyerAddedSuccess({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

/// State when adding a buyer fails.
class BuyerAddedFailure extends SalesState {
  /// Creates a [BuyerAddedFailure] state with [errorMsg].
  const BuyerAddedFailure({required this.errorMsg, super.buyers});

  /// The error message.
  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}

/// State when a buyer is successfully updated.
class BuyerUpdateSuccess extends SalesState {
  /// Creates a [BuyerUpdateSuccess] state.
  const BuyerUpdateSuccess({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

/// State when updating a buyer fails.
class BuyerUpdateFailure extends SalesState {
  /// Creates a [BuyerUpdateFailure] state with [errorMsg].
  const BuyerUpdateFailure({required this.errorMsg, super.buyers});

  /// The error message.
  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}

/// State when a buyer is successfully deleted.
class BuyerDeleteSuccess extends SalesState {
  /// Creates a [BuyerDeleteSuccess] state.
  const BuyerDeleteSuccess({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

/// State when deleting a buyer fails.
class BuyerDeleteFailure extends SalesState {
  /// Creates a [BuyerDeleteFailure] state with [errorMsg].
  const BuyerDeleteFailure({required this.errorMsg, super.buyers});

  /// The error message.
  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}

/// State when buyers are successfully retrieved.
class GetBuyerSuccess extends SalesState {
  /// Creates a [GetBuyerSuccess] state.
  const GetBuyerSuccess({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

/// State when retrieving buyers fails.
class GetBuyerFailure extends SalesState {
  /// Creates a [GetBuyerFailure] state with [errorMsg].
  const GetBuyerFailure({required this.errorMsg, super.buyers});

  /// The error message.
  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}

/// State when a sale is successfully added.
class SaleAddSuccess extends SalesState {
  /// Creates a [SaleAddSuccess] state.
  const SaleAddSuccess({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

/// State when adding a sale fails.
class SalesAddFailure extends SalesState {
  /// Creates a [SalesAddFailure] state with [errorMsg].
  const SalesAddFailure({required this.errorMsg, super.buyers});

  /// The error message.
  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}

/// State when a sale is successfully updated.
class SalesUpdateSuccess extends SalesState {
  /// Creates a [SalesUpdateSuccess] state.
  const SalesUpdateSuccess({super.buyers});

  @override
  List<Object> get props => <Object>[buyers];
}

/// State when updating a sale fails.
class SalesUpdateFailure extends SalesState {
  /// Creates a [SalesUpdateFailure] state with [errorMsg].
  const SalesUpdateFailure({required this.errorMsg, super.buyers});

  /// The error message.
  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}

/// State when sales are successfully retrieved.
class GetSalesSuccessState extends SalesState {
  /// Creates a [GetSalesSuccessState] with [sales].
  const GetSalesSuccessState(this.sales, {super.buyers});

  /// The list of milk sales.
  final List<MilkSale> sales;

  @override
  List<Object> get props => <Object>[buyers, sales];
}

/// State when retrieving sales fails.
class GetSalesFailureState extends SalesState {
  /// Creates a [GetSalesFailureState] with [errorMsg].
  const GetSalesFailureState({required this.errorMsg, super.buyers});

  /// The error message.
  final String errorMsg;

  @override
  List<Object> get props => <Object>[buyers, errorMsg];
}
