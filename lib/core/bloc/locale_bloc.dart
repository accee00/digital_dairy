import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'locale_event.dart';
part 'locale_state.dart';

///
class LocaleBloc extends HydratedBloc<LocaleEvent, LocaleState> {
  ///
  LocaleBloc() : super(const LocaleInitial()) {
    on<LocaleChangeEvent>(_onChangeLocale);
    on<LoadLocale>(_onLoadLocale);
  }
  void _onChangeLocale(LocaleChangeEvent event, Emitter<LocaleState> emit) {
    emit(
      LocaleChanged(
        event.locale,
        hasShownLanguageDialog: event.hasShownLanguageDialog,
      ),
    );
  }

  void _onLoadLocale(LoadLocale event, Emitter<LocaleState> emit) {
    // This will automatically load from storage if available
    // The fromJson method handles the restoration
  }
  @override
  LocaleState? fromJson(Map<String, dynamic> json) {
    try {
      final String languageCode = json['languageCode'] as String;
      final bool hasShownLanguageDialog =
          json['hasShownLanguageDialog'] as bool;
      return LocaleChanged(
        Locale(languageCode),
        hasShownLanguageDialog: hasShownLanguageDialog,
      );
    } catch (_) {
      return const LocaleInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(LocaleState state) => <String, dynamic>{
    'languageCode': state.locale.languageCode,
    'hasShownLanguageDialog': state.hasShownLanguageDialog,
  };
}
