import 'dart:io';

import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

///
class CattleService {
  ///
  CattleService(this.client);

  ///
  final SupabaseClient client;

  ///
  Session? get currentUserSession => client.auth.currentSession;

  ///
  Future<Either<Failure, String>> uploadImage(File image) async {
    try {
      final String uniqueName = const Uuid().v4();
      final String extension = image.path.split('.').last;
      final String path = 'image/$uniqueName.$extension';

      await client.storage.from('cattleimage').upload(path, image);

      final String publicUrl = client.storage
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
      final Cattle i = cattle.copyWith(userId: currentUserSession!.user.id);
      final PostgrestList response = await client
          .from('cattle')
          .insert(i.tojsonForInsert())
          .select();

      final List<Cattle> data = response.map(Cattle.fromMap).toList();
      return right(data);
    } on PostgrestException catch (e) {
      print(e.toString());
      return left(Failure(e.message));
    }
  }

  ///
  Future<Either<Failure, List<Cattle>>> getAllCattle() async {
    try {
      final User? user = currentUserSession?.user;
      if (user == null) {
        return left(Failure('User not logged in.'));
      }

      final PostgrestList response = await client
          .from('cattle')
          .select()
          .eq('user_id', user.id);

      final List<Cattle> data = response.map(Cattle.fromMap).toList();
      print(data.toString());
      return right(data);
    } on PostgrestException catch (e) {
      return left(Failure(e.message));
    }
  }
}
