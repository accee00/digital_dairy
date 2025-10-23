import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/features/sales/model/buyer_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      logInfo(response);
      if (response.isNotEmpty) {
        return right(true);
      }
      return right(false);
    } on PostgrestException catch (e) {
      logInfo(e.toJson());
      return left(Failure(e.message));
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
      logInfo('List of buyers$buyers');
      return right(buyers);
    } on PostgrestException catch (e) {
      logInfo(e.toJson());
      return left(Failure(e.message));
    }
  }
}
