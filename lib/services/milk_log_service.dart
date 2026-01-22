import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///
class MilkLogService {
  ///
  MilkLogService(this._client);

  final SupabaseClient _client;

  String get _userId => _client.auth.currentSession!.user.id;

  ///
  Future<Either<Failure, bool>> addMilkEntry(MilkModel milk) async {
    try {
      final MilkModel updatedData = milk.copyWith(userId: _userId);
      final PostgrestList response = await _client
          .from('milk_entries')
          .insert(updatedData.toMap())
          .select();
      if (response.isNotEmpty) {
        return right(true);
      }
      return right(false);
    } on PostgrestException catch (e) {
      logInfo(e.toString());
      return left(Failure(e.message));
    }
  }

  ///
  Future<Either<Failure, bool>> updateMilkEntry(MilkModel model) async {
    try {
      final PostgrestList response = await _client
          .from('milk_entries')
          .update(model.toMap())
          .eq('id', model.id!)
          .select();
      if (response.isNotEmpty) {
        return right(true);
      }
      return right(false);
    } on PostgrestException catch (e) {
      logInfo(e.toString());
      return left(Failure(e.message));
    }
  }

  ///
  Future<Either<Failure, List<MilkModel>>> getMilkLog({
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final PostgrestList response = await _client.rpc(
        'get_milk_log_with_cattle',
        params: <String, dynamic>{
          'p_user_id': _userId,
          'p_page': page,
          'p_limit': limit,
        },
      );

      final List<MilkModel> milkLogList = response
          .map(MilkModel.fromMap)
          .toList();
      logInfo(milkLogList.length);
      return right(milkLogList);
    } on PostgrestException catch (e) {
      return left(Failure(e.message));
    }
  }

  ///
  Future<Either<Failure, List<MilkModel>>> searchMilk({
    int page = 0,
    int limit = 5,
    String? query,
    String? shift,
    DateTime? date,
    double? minQuantity,
  }) async {
    try {
      final PostgrestList response = await _client.rpc(
        'search_milk_log',
        params: <String, dynamic>{
          'p_user_id': _userId,
          'p_page': page,
          'p_limit': limit,
          'p_search': query?.trim().isEmpty ?? true ? null : query,
          'p_shift': shift,
          'p_date': date?.toIso8601String().split('T').first,
          'p_min_quantity': minQuantity,
        },
      );

      return right(response.map(MilkModel.fromMap).toList());
    } on PostgrestException catch (e) {
      logInfo('Search milk error: ${e.toString()}');
      return left(Failure(e.message));
    } catch (e) {
      logInfo('Search milk error: ${e.toString()}');
      return left(Failure(e.toString()));
    }
  }
}
