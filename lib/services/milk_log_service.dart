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

  /// Searches and get milk logs with cursor-based pagination.
  Future<Either<Failure, List<MilkModel>>> searchAndGetMilkLog({
    int limit = 20,
    String? query,
    String? shift,
    DateTime? startDate,
    DateTime? endDate,
    bool sortByQuantity = false,
    DateTime? lastCreatedAt,
    String? lastId,
  }) async {
    try {
      logInfo(
        'searchAndGetMilkLog | '
        'limit=$limit | '
        'query=$query | '
        'shift=$shift | '
        'sortByQuantity=$sortByQuantity | '
        'lastId=$lastId',
      );
      final PostgrestList response = await _client.rpc(
        'search_milk_log_cursor',
        params: <String, dynamic>{
          'p_user_id': _userId,
          'p_limit': limit,
          'p_search': (query == null || query.trim().isEmpty)
              ? null
              : query.trim(),
          'p_shift': shift,
          'p_last_created_at': lastCreatedAt?.toIso8601String(),
          'p_last_id': lastId,
          'p_sort_by_quantity': sortByQuantity,
        },
      );

      return right(response.map(MilkModel.fromMap).toList());
    } on PostgrestException catch (e) {
      logInfo('Search milk error: $e');
      return left(Failure(e.message));
    } catch (e) {
      logInfo('Search milk general error: $e');
      return left(Failure('An unexpected error occurred'));
    }
  }
}
