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
  SalesCubit(this._salesService) : super(const SalesInitial());

  ///
  final SalesService _salesService;

  ///
  Future<void> addBuyer(Buyer buyer) async {
    emit(SalesLoading(buyers: state.buyers));

    final Either<Failure, bool> response = await _salesService.addBuyer(buyer);

    response.match(
      (Failure failure) => emit(
        BuyerAddedFailure(errorMsg: failure.message, buyers: state.buyers),
      ),
      (bool success) async {
        if (!success) {
          emit(
            BuyerAddedFailure(
              errorMsg: 'Unexpected error occurred.',
              buyers: state.buyers,
            ),
          );
          return;
        }
        final Either<Failure, List<Buyer>> updatedBuyers = await _salesService
            .getBuyers();

        updatedBuyers.match(
          (Failure failure) => emit(
            BuyerAddedFailure(errorMsg: failure.message, buyers: state.buyers),
          ),
          (List<Buyer> buyers) => emit(BuyerAddedSuccess(buyers: buyers)),
        );
      },
    );
  }

  ///
  Future<void> updateBuyer(Buyer buyer) async {
    emit(SalesLoading(buyers: state.buyers));

    final Either<Failure, bool> response = await _salesService.updateBuyer(
      buyer,
    );

    response.match(
      (Failure failure) => emit(
        BuyerUpdateFailure(errorMsg: failure.message, buyers: state.buyers),
      ),
      (bool success) async {
        if (!success) {
          emit(
            BuyerUpdateFailure(
              errorMsg: 'Unexpected error occurred.',
              buyers: state.buyers,
            ),
          );
          return;
        }
        final Either<Failure, List<Buyer>> updatedBuyers = await _salesService
            .getBuyers();

        updatedBuyers.match(
          (Failure failure) => emit(
            BuyerUpdateFailure(errorMsg: failure.message, buyers: state.buyers),
          ),
          (List<Buyer> buyers) => emit(BuyerUpdateSuccess(buyers: buyers)),
        );
      },
    );
  }

  ///
  Future<void> deleteBuyer(String buyerId) async {
    emit(SalesLoading(buyers: state.buyers));

    final Either<Failure, bool> response = await _salesService.deleteBuyer(
      buyerId,
    );

    response.match(
      (Failure failure) => emit(
        BuyerDeleteFailure(errorMsg: failure.message, buyers: state.buyers),
      ),
      (bool success) async {
        if (!success) {
          emit(
            BuyerDeleteFailure(
              errorMsg: 'Unexpected error occurred.',
              buyers: state.buyers,
            ),
          );
          return;
        }
        final Either<Failure, List<Buyer>> updatedBuyers = await _salesService
            .getBuyers();

        updatedBuyers.match(
          (Failure failure) => emit(
            BuyerDeleteFailure(errorMsg: failure.message, buyers: state.buyers),
          ),
          (List<Buyer> buyers) => emit(BuyerDeleteSuccess(buyers: buyers)),
        );
      },
    );
  }

  ///
  Future<void> getBuyers() async {
    emit(SalesLoading(buyers: state.buyers));
    final Either<Failure, List<Buyer>> response = await _salesService
        .getBuyers();
    response.fold(
      (Failure failure) => emit(
        GetBuyerFailure(errorMsg: failure.message, buyers: state.buyers),
      ),
      (List<Buyer> buyers) => emit(GetBuyerSuccess(buyers: buyers)),
    );
  }

  ///
  Future<void> addSales(MilkSale sale) async {
    emit(SalesLoading(buyers: state.buyers));

    final Either<Failure, bool> response = await _salesService.addSales(sale);

    response.fold(
      (Failure failure) => emit(
        SalesAddFailure(errorMsg: failure.message, buyers: state.buyers),
      ),
      (_) => emit(SaleAddSuccess(buyers: state.buyers)),
    );
  }

  ///
  Future<void> updateSales(MilkSale sale) async {
    emit(SalesLoading(buyers: state.buyers));

    final Either<Failure, bool> response = await _salesService.updateSales(
      sale,
    );

    response.fold(
      (Failure failure) => emit(
        SalesUpdateFailure(errorMsg: failure.message, buyers: state.buyers),
      ),
      (_) => emit(SalesUpdateSuccess(buyers: state.buyers)),
    );
  }

  ///
  Future<void> getSales({
    required String buyerId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(SalesLoading(buyers: state.buyers));

    final Either<Failure, List<MilkSale>> response = await _salesService
        .getSales(buyerId, startDate, endDate);

    response.fold(
      (Failure failure) => emit(
        GetSalesFailureState(errorMsg: failure.message, buyers: state.buyers),
      ),
      (List<MilkSale> sales) =>
          emit(GetSalesSuccessState(sales, buyers: state.buyers)),
    );
  }

  ///
  void clear() {
    emit(const SalesInitial());
  }
}
