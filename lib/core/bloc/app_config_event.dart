part of 'app_config_bloc.dart';

///
abstract class AppConfigEvent extends Equatable {
  ///
  const AppConfigEvent();

  @override
  List<Object?> get props => <Object?>[];
}

///
class LocaleChangeEvent extends AppConfigEvent {
  ///
  const LocaleChangeEvent(this.locale, {required this.hasShownLanguageDialog});

  ///
  final Locale locale;

  ///
  final bool hasShownLanguageDialog;
}

///
class LoadLocale extends AppConfigEvent {}

///
class ThemeChangeEvent extends AppConfigEvent {
  ///
  const ThemeChangeEvent(this.themeMode);

  ///
  final ThemeMode themeMode;

  @override
  List<Object?> get props => <Object?>[themeMode];
}
