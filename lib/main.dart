import 'dart:async';

import 'package:digital_dairy/core/bloc/locale_bloc.dart';
import 'package:digital_dairy/core/di/init_di.dart';
import 'package:digital_dairy/core/routes/go_route.dart';
import 'package:digital_dairy/core/theme/app_theme.dart';
import 'package:digital_dairy/features/auth/cubit/auth_cubit.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
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
      BlocProvider<LocaleBloc>(create: (_) => serviceLocator<LocaleBloc>()),
      BlocProvider<AuthCubit>(create: (_) => serviceLocator<AuthCubit>()),
      BlocProvider<CattleCubit>(create: (_) => serviceLocator<CattleCubit>()),
      BlocProvider<MilkCubit>(create: (_) => serviceLocator<MilkCubit>()),
      BlocProvider<SalesCubit>(create: (_) => serviceLocator<SalesCubit>()),
    ],
    child: BlocBuilder<LocaleBloc, LocaleState>(
      builder: (BuildContext context, LocaleState state) => MaterialApp.router(
        routerConfig: AppRouteConfig.router,
        debugShowCheckedModeBanner: false,
        title: 'Digital Dairy',
        darkTheme: AppTheme.darkTheme,
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: state.locale,
      ),
    ),
  );
}
