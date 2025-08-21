import 'dart:async';

import 'package:digital_dairy/core/bloc/locale_bloc.dart';
import 'package:digital_dairy/core/di/init_di.dart';
import 'package:digital_dairy/core/routes/go_route.dart';
import 'package:digital_dairy/features/auth/cubit/auth_cubit.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/l10n/localization/app_localizations.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
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
    ],
    child: BlocBuilder<LocaleBloc, LocaleState>(
      builder: (BuildContext context, LocaleState state) => MaterialApp.router(
        routerConfig: AppRouteConfig.router,
        debugShowCheckedModeBanner: false,
        title: 'Digital Dairy',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: state.locale,
      ),
    ),
  );
}
