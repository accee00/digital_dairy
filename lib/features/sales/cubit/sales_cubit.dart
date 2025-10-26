import 'package:bloc/bloc.dart';
import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/features/sales/model/buyer_model.dart';
import 'package:digital_dairy/features/sales/model/milk_sales_model.dart';
import 'package:digital_dairy/services/sales_service.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'sales_state.dart';

///
class SalesCubit extends Cubit<SalesState> {
  ///
  SalesCubit(this._salesService) : super(SalesInitial());

  ///
  final SalesService _salesService;

  ///
  Future<void> addBuyer(Buyer buyer) async {
    final List<MilkSale> milkSales = state.milkSales;
    final List<Buyer> buyers = state.buyers;

    final Either<Failure, bool> response = await _salesService.addBuyer(buyer);

    response.fold(
      (Failure failure) => emit(
        BuyerAddedFailure(
          errorMsg: failure.message,
          milkSales: milkSales,
          buyers: buyers,
        ),
      ),
      (bool success) {
        if (success) {
          emit(BuyerAddedSuccess(milkSales: milkSales, buyers: buyers));
        } else {
          emit(
            BuyerAddedFailure(
              errorMsg: 'Unexpected error occurred.',
              milkSales: milkSales,
              buyers: buyers,
            ),
          );
        }
      },
    );
  }

  ///
  Future<void> getBuyers() async {
    final List<MilkSale> milkSales = state.milkSales;

    final Either<Failure, List<Buyer>> response = await _salesService
        .getBuyers();
    print(response);
    response.fold(
      (Failure failure) => emit(
        GetBuyerFailure(
          errorMsg: failure.message,
          milkSales: milkSales,
          buyers: state.buyers,
        ),
      ),
      (List<Buyer> buyers) =>
          emit(GetBuyerSuccess(buyers: buyers, milkSales: milkSales)),
    );
  }
}
