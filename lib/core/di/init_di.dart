import 'package:digital_dairy/core/bloc/locale_bloc.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/features/auth/cubit/auth_cubit.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/milklog/cubit/milk_cubit.dart';
import 'package:digital_dairy/services/auth_service.dart';
import 'package:digital_dairy/services/cattle_service.dart';
import 'package:digital_dairy/services/milk_log_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///
final GetIt serviceLocator = GetIt.instance;

///
Future<void> initDi() async {
  initLogger(level: kDebugMode ? Level.ALL : Level.SEVERE);
  final Supabase supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  final HydratedStorage storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationSupportDirectory()).path,
          ),
  );
  HydratedBloc.storage = storage;

  serviceLocator.registerLazySingleton(() => supabase.client);
  initService();
  initCubits();
}

///
void initService() {
  serviceLocator
    ..registerFactory(() => AuthService(serviceLocator<SupabaseClient>()))
    ..registerFactory(() => CattleService(serviceLocator<SupabaseClient>()))
    ..registerFactory(() => MilkLogService(serviceLocator<SupabaseClient>()));
}

///
void initCubits() {
  serviceLocator
    ..registerLazySingleton<LocaleBloc>(LocaleBloc.new)
    ..registerFactory<AuthCubit>(() => AuthCubit(serviceLocator<AuthService>()))
    ..registerFactory(() => CattleCubit(serviceLocator<CattleService>()))
    ..registerFactory(() => MilkCubit(serviceLocator<MilkLogService>()));
}
