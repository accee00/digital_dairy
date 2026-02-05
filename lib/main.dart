import 'dart:async';

import 'package:digital_dairy/core/bloc/app_config_bloc.dart';
import 'package:digital_dairy/core/di/init_di.dart';
import 'package:digital_dairy/core/routes/go_route.dart';
import 'package:digital_dairy/core/theme/app_theme.dart';
import 'package:digital_dairy/features/auth/cubit/auth_cubit.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/home/cubit/analytics_cubit.dart';
import 'package:digital_dairy/features/home/cubit/profile_cubit.dart';
import 'package:digital_dairy/features/milklog/cubit/milk_cubit.dart';
import 'package:digital_dairy/features/sales/cubit/sales_cubit.dart';
import 'package:digital_dairy/l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nested/nested.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initDi();
  runApp(const MyApp());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  });
}

///
class MyApp extends StatelessWidget {
  ///
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: <SingleChildWidget>[
      BlocProvider<AppConfigBloc>(
        create: (_) => serviceLocator<AppConfigBloc>(),
      ),
      BlocProvider<AuthCubit>(create: (_) => serviceLocator<AuthCubit>()),
      BlocProvider<ProfileCubit>(
        create: (_) => serviceLocator<ProfileCubit>()..fetchProfile(),
      ),
      BlocProvider<AnalyticsCubit>(
        create: (_) => serviceLocator<AnalyticsCubit>(),
      ),
      BlocProvider<CattleCubit>(create: (_) => serviceLocator<CattleCubit>()),
      BlocProvider<MilkCubit>(create: (_) => serviceLocator<MilkCubit>()),
      BlocProvider<SalesCubit>(create: (_) => serviceLocator<SalesCubit>()),
    ],
    child: BlocBuilder<AppConfigBloc, AppConfigState>(
      builder: (BuildContext context, AppConfigState state) =>
          MaterialApp.router(
            routerConfig: AppRouteConfig.router,
            debugShowCheckedModeBanner: false,
            title: 'Digital Dairy',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: state.locale,
          ),
    ),
  );
}
