import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'app_config_event.dart';
part 'app_config_state.dart';

///
class AppConfigBloc extends HydratedBloc<AppConfigEvent, AppConfigState> {
  ///
  AppConfigBloc() : super(const LocaleInitial()) {
    on<LocaleChangeEvent>(_onChangeLocale);
    on<LoadLocale>(_onLoadLocale);
    on<ThemeChangeEvent>(_onChangeTheme);
  }

  void _onChangeLocale(LocaleChangeEvent event, Emitter<AppConfigState> emit) {
    emit(
      state.copyWith(
        locale: event.locale,
        hasShownLanguageDialog: event.hasShownLanguageDialog,
      ),
    );
  }

  void _onLoadLocale(LoadLocale event, Emitter<AppConfigState> emit) {
    // This will automatically load from storage if available
    // The fromJson method handles the restoration
  }

  void _onChangeTheme(ThemeChangeEvent event, Emitter<AppConfigState> emit) {
    emit(state.copyWith(themeMode: event.themeMode));
  }

  @override
  AppConfigState? fromJson(Map<String, dynamic> json) {
    try {
      final String languageCode = json['languageCode'] as String;
      final bool hasShownLanguageDialog =
          json['hasShownLanguageDialog'] as bool? ?? false;
      final String? themeModeString = json['themeMode'] as String?;

      final ThemeMode themeMode = themeModeString != null
          ? ThemeMode.values.firstWhere(
              (ThemeMode e) => e.toString() == themeModeString,
              orElse: () => ThemeMode.system,
            )
          : ThemeMode.system;

      return LocaleChanged(
        Locale(languageCode),
        hasShownLanguageDialog: hasShownLanguageDialog,
        themeMode: themeMode,
      );
    } catch (_) {
      return const LocaleInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(AppConfigState state) => <String, dynamic>{
    'languageCode': state.locale.languageCode,
    'hasShownLanguageDialog': state.hasShownLanguageDialog,
    'themeMode': state.themeMode.toString(),
  };
}
