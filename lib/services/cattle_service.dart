import 'dart:io';

import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

///
class CattleService {
  ///
  CattleService(this._client);

  ///
  final SupabaseClient _client;

  ///
  String get _userId => _client.auth.currentSession!.user.id;

  ///
  Future<Either<Failure, String>> uploadImage(File image) async {
    try {
      final String uniqueName = const Uuid().v4();
      final String extension = image.path.split('.').last;
      final String path = 'image/$uniqueName.$extension';

      await _client.storage.from('cattleimage').upload(path, image);

      final String publicUrl = _client.storage
          .from('cattleimage')
          .getPublicUrl(path);

      return right(publicUrl);
    } on StorageException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error: $e'));
    }
  }

  ///
  Future<Either<Failure, List<Cattle>>> createCattle(Cattle cattle) async {
    try {
      final Cattle updatedData = cattle.copyWith(userId: _userId);
      final PostgrestList response = await _client
          .from('cattle')
          .insert(updatedData.tojsonForInsert())
          .select();

      final List<Cattle> data = response.map(Cattle.fromMap).toList();
      return right(data);
    } on PostgrestException catch (e) {
      return left(Failure(e.message));
    }
  }

  ///
  Future<Either<Failure, Cattle>> updateCattle(Cattle cattle) async {
    try {
      logInfo('Cattle id [updatedCattle]=> ${cattle.id}');
      final PostgrestMap response = await _client
          .from('cattle')
          .update(cattle.tojsonForUpdate())
          .eq('id', cattle.id!)
          .eq('user_id', _userId)
          .select()
          .single();

      final Cattle data = Cattle.fromMap(response);
      return right(data);
    } on PostgrestException catch (e) {
      return left(Failure(e.message));
    }
  }

  ///
  Future<Either<Failure, bool>> deleteCattle(String cattleId) async {
    try {
      await _client
          .from('cattle')
          .delete()
          .eq('id', cattleId)
          .eq('user_id', _userId);

      return right(true);
    } on PostgrestException catch (e) {
      return left(Failure(e.message));
    }
  }

  ///
  Future<Either<Failure, List<Cattle>>> getAllCattle() async {
    try {
      final List<Map<String, dynamic>> response = await _client
          .rpc<List<Map<String, dynamic>>>(
            'get_cattle_with_monthly_milk',
            params: <String, dynamic>{'p_user_id': _userId},
          );

      final List<Cattle> data = response.map(Cattle.fromMap).toList();
      logInfo(data);
      return right(data);
    } on PostgrestException catch (e) {
      logInfo('Get cattle failure:$e');
      return left(Failure(e.message));
    }
  }

  ///
  Future<Either<Failure, List<MilkModel>>> getMilkLogByCattle({
    required String cattleId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final PostgrestList response = await _client
          .from('milk_entries')
          .select()
          .eq('user_id', _userId)
          .eq('cattle_id', cattleId)
          .gte('date', startDate.toIso8601String())
          .lte('date', endDate.toIso8601String())
          .order('date', ascending: true);

      final List<MilkModel> data = response.map(MilkModel.fromMap).toList();

      return right(data);
    } on PostgrestException catch (e) {
      return left(Failure(e.message));
    }
  }
}
