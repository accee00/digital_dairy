import 'package:digital_dairy/core/bloc/locale_bloc.dart';
import 'package:digital_dairy/core/routes/go_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nested/nested.dart';

import 'package:digital_dairy/core/di/init_di.dart';
import 'package:digital_dairy/features/auth/cubit/auth_cubit.dart';
import 'package:digital_dairy/l10n/localization/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initDi();
  runApp(const MyApp());
}

///
class MyApp extends StatelessWidget {
  ///
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: <SingleChildWidget>[
      BlocProvider<LocaleBloc>(create: (_) => serviceLocator()),
      BlocProvider<AuthCubit>(create: (_) => serviceLocator()),
    ],
    child: BlocBuilder<LocaleBloc, LocaleState>(
      builder: (BuildContext context, LocaleState state) => MaterialApp.router(
        routerConfig: AppRouteConfig.router,
        title: 'Digital Dairy',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: state.locale,
      ),
    ),
  );
}
