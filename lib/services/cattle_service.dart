import 'dart:io';

import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
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
  Future<Either<Failure, List<Cattle>>> getAllCattle() async {
    try {
      final PostgrestList response = await _client
          .from('cattle')
          .select()
          .eq('user_id', _userId);

      final List<Cattle> data = response.map(Cattle.fromMap).toList();
      return right(data);
    } on PostgrestException catch (e) {
      return left(Failure(e.message));
    }
  }
}
