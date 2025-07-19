import 'package:digital_dairy/features/auth/cubit/auth_cubit.dart';
import 'package:digital_dairy/services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///
final GetIt serviceLocator = GetIt.instance;

///
Future<void> initDi() async {
  final Supabase supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  initService();
  initCubits();
}

///
void initService() {
  serviceLocator.registerFactory(() => AuthService(serviceLocator()));
}

///
void initCubits() {
  serviceLocator.registerFactory<AuthCubit>(
    () => AuthCubit(serviceLocator<AuthService>()),
  );
}
