import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/features/sales/model/buyer_model.dart';
import 'package:digital_dairy/features/sales/model/milk_sales_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///
class SalesService {
  ///
  SalesService(this._client);

  ///
  final SupabaseClient _client;

  ///
  String get _userId => _client.auth.currentSession!.user.id;

  ///
  Future<Either<Failure, bool>> addBuyer(Buyer buyer) async {
    try {
      final PostgrestList response = await _client
          .from('buyers')
          .insert(buyer.copyWith(userId: _userId))
          .select();
      logInfo('Add buyers success: $response');
      if (response.isNotEmpty) {
        return right(true);
      }
      return right(false);
    } on PostgrestException catch (e) {
      logInfo('Add buyer failure: ${e.toJson()}');
      return left(Failure(e.message));
    } catch (e) {
      logInfo('Unexpected error: $e');
      return left(Failure('An unexpected error occurred'));
    }
  }

  ///
  Future<Either<Failure, bool>> updateBuyer(Buyer buyer) async {
    try {
      final PostgrestList response = await _client
          .from('buyers')
          .update(buyer.toJson())
          .eq('id', buyer.id!)
          .select();

      logInfo('Update buyers success: $response');
      if (response.isNotEmpty) {
        return right(true);
      }
      return right(false);
    } on PostgrestException catch (e) {
      logInfo('Update buyer failure: ${e.toJson()}');
      return left(Failure(e.message));
    } catch (e) {
      logInfo('Unexpected error: $e');
      return left(Failure('An unexpected error occurred'));
    }
  }

  ///
  Future<Either<Failure, List<Buyer>>> getBuyers() async {
    try {
      final PostgrestList response = await _client
          .from('buyers')
          .select()
          .eq('user_id', _userId);

      final List<Buyer> buyers = response.map(Buyer.fromJson).toList();
      logInfo('Get buyers success: $buyers');
      return right(buyers);
    } on PostgrestException catch (e) {
      logInfo('Get buyer failure: ${e.toJson()}');
      return left(Failure(e.message));
    } catch (e) {
      logInfo('Unexpected error: $e');
      return left(Failure('An unexpected error occurred'));
    }
  }

  ///
  Future<Either<Failure, bool>> addSales(MilkSale sale) async {
    try {
      final PostgrestList response = await _client
          .from('milk_sales')
          .insert(sale.copyWith(userId: _userId).toJson())
          .select();
      logInfo('Add milk sale response: $response');
      if (response.isNotEmpty) {
        return right(true);
      }
      return right(false);
    } on PostgrestException catch (e) {
      logInfo('Add milk sale failure: ${e.toJson()}');
      return left(Failure(e.message));
    } catch (e) {
      logInfo('Unexpected error: $e');
      return left(Failure('An unexpected error occurred'));
    }
  }

  ///
  Future<Either<Failure, bool>> updateSales(MilkSale sale) async {
    try {
      final PostgrestList response = await _client
          .from('milk_sales')
          .update(sale.toJson())
          .eq('id', sale.id!)
          .select();
      logInfo('Update milk sale response: $response');
      if (response.isNotEmpty) {
        return right(true);
      }
      return right(false);
    } on PostgrestException catch (e) {
      logInfo('Update milk sale failure: ${e.toJson()}');
      return left(Failure(e.message));
    } catch (e) {
      logInfo('Unexpected error: $e');
      return left(Failure('An unexpected error occurred'));
    }
  }

  ///
  Future<Either<Failure, List<MilkSale>>> getSales(
    String buyerId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final PostgrestList response = await _client
          .from('milk_sales')
          .select()
          .eq('buyer_id', buyerId)
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', endDate.toIso8601String())
          .order('created_at', ascending: false);

      final List<MilkSale> sales = response.map(MilkSale.fromJson).toList();

      return right(sales);
    } on PostgrestException catch (e) {
      logInfo('Get milk sale failure: ${e.toJson()}');
      return left(Failure(e.message));
    } catch (e) {
      logInfo('Unexpected error: $e');
      return left(Failure('An unexpected error occurred'));
    }
  }
}
