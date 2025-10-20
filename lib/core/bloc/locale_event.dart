part of 'locale_bloc.dart';

///
abstract class LocaleEvent extends Equatable {
  ///
  const LocaleEvent();

  @override
  List<Object?> get props => <Object?>[];
}

///
class LocaleChangeEvent extends LocaleEvent {
  ///
  const LocaleChangeEvent(this.locale, {required this.hasShownLanguageDialog});

  ///
  final Locale locale;

  ///
  final bool hasShownLanguageDialog;
}

///
class LoadLocale extends LocaleEvent {}
