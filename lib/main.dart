import 'package:digital_dairy/features/auth/presentation/view/splash_screen.dart';
import 'package:digital_dairy/l10n/localization/app_localizations.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

///
class MyApp extends StatelessWidget {
  ///
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
    title: 'Digital Dairy',
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: Locale('eng'),
    home: SplashScreen(),
  );
}
