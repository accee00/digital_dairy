import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsService {
  ///
  AnalyticsService(this._client);

  final SupabaseClient _client;

  String get _userId => _client.auth.currentSession!.user.id;
}
