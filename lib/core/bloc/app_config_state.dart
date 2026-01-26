part of 'app_config_bloc.dart';

///
abstract class AppConfigState extends Equatable {
  ///
  const AppConfigState({
    required this.locale,
    this.hasShownLanguageDialog = false,
    this.themeMode = ThemeMode.system,
  });

  ///
  final Locale locale;

  ///
  final bool hasShownLanguageDialog;

  ///
  final ThemeMode themeMode;

  ///
  bool get isDarkMode => themeMode == ThemeMode.dark;

  ///
  bool get isLightMode => themeMode == ThemeMode.light;

  ///
  bool get isSystemMode => themeMode == ThemeMode.system;

  ///
  AppConfigState copyWith({
    Locale? locale,
    bool? hasShownLanguageDialog,
    ThemeMode? themeMode,
  });

  @override
  List<Object?> get props => <Object?>[
    locale,
    hasShownLanguageDialog,
    themeMode,
  ];
}

///
class LocaleInitial extends AppConfigState {
  ///
  const LocaleInitial()
    : super(
        locale: const Locale('en'),
        hasShownLanguageDialog: false,
        themeMode: ThemeMode.system,
      );

  @override
  AppConfigState copyWith({
    Locale? locale,
    bool? hasShownLanguageDialog,
    ThemeMode? themeMode,
  }) => LocaleChanged(
    locale ?? this.locale,
    hasShownLanguageDialog:
        hasShownLanguageDialog ?? this.hasShownLanguageDialog,
    themeMode: themeMode ?? this.themeMode,
  );
}

///
class LocaleChanged extends AppConfigState {
  ///
  const LocaleChanged(
    Locale locale, {
    super.hasShownLanguageDialog,
    super.themeMode,
  }) : super(locale: locale);

  @override
  AppConfigState copyWith({
    Locale? locale,
    bool? hasShownLanguageDialog,
    ThemeMode? themeMode,
  }) => LocaleChanged(
    locale ?? this.locale,
    hasShownLanguageDialog:
        hasShownLanguageDialog ?? this.hasShownLanguageDialog,
    themeMode: themeMode ?? this.themeMode,
  );
}
