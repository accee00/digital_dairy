part of 'locale_bloc.dart';

///
abstract class LocaleState extends Equatable {
  const LocaleState(this.locale, {required this.hasShownLanguageDialog});
  final Locale locale;
  final bool hasShownLanguageDialog;

  @override
  List<Object> get props => <Object>[locale, hasShownLanguageDialog];
}

///
class LocaleInitial extends LocaleState {
  ///
  const LocaleInitial()
    : super(const Locale('en'), hasShownLanguageDialog: false);
}

///
class LocaleChanged extends LocaleState {
  ///
  const LocaleChanged(super.locale, {required super.hasShownLanguageDialog});
}
