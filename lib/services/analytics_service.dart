import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/features/home/model/analytics_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///
class AnalyticsService {
  ///
  AnalyticsService(this._client);

  ///
  final SupabaseClient _client;

  ///
  String get _userId => _client.auth.currentSession!.user.id;

  ///
  Future<Either<Failure, AnalyticsModel>> getDashboardAnalytics() async {
    try {
      final List<Map<String, dynamic>> response = await _client
          .rpc<List<Map<String, dynamic>>>(
            'get_milk_dashboard_stats',
            params: <String, dynamic>{'p_user_id': _userId},
          );

      if (response.isEmpty) {
        return left(Failure('No analytics data available'));
      }

      final Map<String, dynamic> analyticsData = response.first;

      return right(AnalyticsModel.fromJson(analyticsData));
    } on PostgrestException catch (e) {
      return left(Failure('Database error: ${e.message}'));
    }
  }
}
