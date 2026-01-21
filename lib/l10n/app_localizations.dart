import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Digital Dairy'**
  String get appName;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Your Smart Companion for Daily Milk Records.'**
  String get splashTagline;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track. Analyze. Grow.'**
  String get splashSubtitle;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get splashLoading;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get onboardingPrevious;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// No description provided for @authLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get authLogout;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get authWelcomeBack;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get authCreateAccount;

  /// No description provided for @authContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get authContinue;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get authEmail;

  /// No description provided for @authEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEnterEmail;

  /// No description provided for @authEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get authEmailRequired;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get authInvalidEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authEnterPassword;

  /// No description provided for @authInvalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authInvalidPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsDoNotMatch;

  /// No description provided for @authPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get authPasswordRequired;

  /// No description provided for @authConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get authConfirmPasswordRequired;

  /// No description provided for @authName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authName;

  /// No description provided for @authEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get authEnterName;

  /// No description provided for @authNameRequires.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get authNameRequires;

  /// No description provided for @authPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get authPhone;

  /// No description provided for @authEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get authEnterPhone;

  /// No description provided for @authInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get authInvalidPhone;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPassword;

  /// No description provided for @authOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get authOr;

  /// No description provided for @authWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get authWithGoogle;

  /// No description provided for @authWithApple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get authWithApple;

  /// No description provided for @formSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get formSubmit;

  /// No description provided for @formCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get formCancel;

  /// No description provided for @formSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get formSave;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get errorNetwork;

  /// No description provided for @errorRequiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get errorRequiredField;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Digital Dairy! Let\'s make your farming smarter and more efficient.'**
  String get welcome;

  /// No description provided for @authAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get authAgreeTerms;

  /// No description provided for @authTermsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get authTermsConditions;

  /// No description provided for @authPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get authPrivacyPolicy;

  /// No description provided for @authCreateAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccountAction;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authAlreadyHaveAccount;

  /// No description provided for @authWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Digital Dairy'**
  String get authWelcome;

  /// No description provided for @authSignInToAccount.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to your account'**
  String get authSignInToAccount;

  /// No description provided for @authDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authDontHaveAccount;

  /// No description provided for @authForgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! Enter your email address and we\'ll send you a link to reset your password.'**
  String get authForgotPasswordDescription;

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authSendResetLink;

  /// No description provided for @authRememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get authRememberPassword;

  /// No description provided for @authBackToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get authBackToSignIn;

  /// No description provided for @authResetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent to your email successfully!'**
  String get authResetLinkSent;

  /// No description provided for @authResetPasswordHelp.
  ///
  /// In en, this message translates to:
  /// **'If you don\'t receive the email within a few minutes, please check your spam folder or contact support.'**
  String get authResetPasswordHelp;

  /// No description provided for @navbarHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navbarHome;

  /// No description provided for @navbarMilKLog.
  ///
  /// In en, this message translates to:
  /// **'Milk Log'**
  String get navbarMilKLog;

  /// No description provided for @navbarCattle.
  ///
  /// In en, this message translates to:
  /// **'Cattle'**
  String get navbarCattle;

  /// No description provided for @navbarReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navbarReports;

  /// No description provided for @milkAddEntry.
  ///
  /// In en, this message translates to:
  /// **'Add Milk Entry'**
  String get milkAddEntry;

  /// No description provided for @milkEditEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit Milk Entry'**
  String get milkEditEntry;

  /// No description provided for @milkCattleSelection.
  ///
  /// In en, this message translates to:
  /// **'Cattle Selection'**
  String get milkCattleSelection;

  /// No description provided for @milkSelectCattle.
  ///
  /// In en, this message translates to:
  /// **'Select Cattle *'**
  String get milkSelectCattle;

  /// No description provided for @milkMilkingDetails.
  ///
  /// In en, this message translates to:
  /// **'Milking Details'**
  String get milkMilkingDetails;

  /// No description provided for @milkMilkingDate.
  ///
  /// In en, this message translates to:
  /// **'Milking Date *'**
  String get milkMilkingDate;

  /// No description provided for @milkSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get milkSelectDate;

  /// No description provided for @milkShift.
  ///
  /// In en, this message translates to:
  /// **'Shift *'**
  String get milkShift;

  /// No description provided for @milkSelectShift.
  ///
  /// In en, this message translates to:
  /// **'Select shift'**
  String get milkSelectShift;

  /// No description provided for @milkQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity (Litres) *'**
  String get milkQuantity;

  /// No description provided for @milkEnterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get milkEnterQuantity;

  /// No description provided for @milkQuantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Quantity is required'**
  String get milkQuantityRequired;

  /// No description provided for @milkEnterValidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter valid quantity'**
  String get milkEnterValidQuantity;

  /// No description provided for @milkTip.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get milkTip;

  /// No description provided for @milkTipText.
  ///
  /// In en, this message translates to:
  /// **'Record milk production immediately after milking for accuracy'**
  String get milkTipText;

  /// No description provided for @milkAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get milkAdditionalInfo;

  /// No description provided for @milkNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get milkNotes;

  /// No description provided for @milkNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes about milk quality, cattle health, or any issues...'**
  String get milkNotesHint;

  /// No description provided for @milkCommonNotes.
  ///
  /// In en, this message translates to:
  /// **'Common Notes:'**
  String get milkCommonNotes;

  /// No description provided for @milkGoodQuality.
  ///
  /// In en, this message translates to:
  /// **'Good quality'**
  String get milkGoodQuality;

  /// No description provided for @milkSlightlyLowYield.
  ///
  /// In en, this message translates to:
  /// **'Slightly low yield'**
  String get milkSlightlyLowYield;

  /// No description provided for @milkNormalProduction.
  ///
  /// In en, this message translates to:
  /// **'Normal production'**
  String get milkNormalProduction;

  /// No description provided for @milkCattleSeemsHealthy.
  ///
  /// In en, this message translates to:
  /// **'Cattle seems healthy'**
  String get milkCattleSeemsHealthy;

  /// No description provided for @milkSaveEntry.
  ///
  /// In en, this message translates to:
  /// **'Save Milk Entry'**
  String get milkSaveEntry;

  /// No description provided for @milkUpdateEntry.
  ///
  /// In en, this message translates to:
  /// **'Update Milk Entry'**
  String get milkUpdateEntry;

  /// No description provided for @milkSelectCattleError.
  ///
  /// In en, this message translates to:
  /// **'Please select a cattle'**
  String get milkSelectCattleError;

  /// No description provided for @milkEntryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Milk entry updated successfully!'**
  String get milkEntryUpdated;

  /// No description provided for @milkEntryRecorded.
  ///
  /// In en, this message translates to:
  /// **'Milk entry recorded successfully!'**
  String get milkEntryRecorded;

  /// No description provided for @jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get jan;

  /// No description provided for @feb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get feb;

  /// No description provided for @mar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get mar;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get aug;

  /// No description provided for @sep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get sep;

  /// No description provided for @oct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get oct;

  /// No description provided for @nov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get nov;

  /// No description provided for @dec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get dec;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @milkScreenSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by cattle ID or notes...'**
  String get milkScreenSearchHint;

  /// No description provided for @milkScreenSortFilterOptions.
  ///
  /// In en, this message translates to:
  /// **'Sort & Filter Options'**
  String get milkScreenSortFilterOptions;

  /// No description provided for @milkScreenNoEntriesFound.
  ///
  /// In en, this message translates to:
  /// **'No milk entries found'**
  String get milkScreenNoEntriesFound;

  /// No description provided for @milkScreenAdjustFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get milkScreenAdjustFilters;

  /// No description provided for @milkScreenSummaryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get milkScreenSummaryTotal;

  /// No description provided for @milkScreenSummaryMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get milkScreenSummaryMorning;

  /// No description provided for @milkScreenSummaryEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get milkScreenSummaryEvening;

  /// No description provided for @milkScreenEntryDetail.
  ///
  /// In en, this message translates to:
  /// **'Milk Entry Details'**
  String get milkScreenEntryDetail;

  /// No description provided for @milkScreenEntryCattle.
  ///
  /// In en, this message translates to:
  /// **'Cattle'**
  String get milkScreenEntryCattle;

  /// No description provided for @milkScreenEntryDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get milkScreenEntryDate;

  /// No description provided for @milkScreenEntryShift.
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get milkScreenEntryShift;

  /// No description provided for @milkScreenEntryQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get milkScreenEntryQuantity;

  /// No description provided for @milkScreenEntryNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get milkScreenEntryNotes;

  /// No description provided for @milkScreenToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get milkScreenToday;

  /// No description provided for @milkScreenYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get milkScreenYesterday;

  /// No description provided for @milkScreenClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get milkScreenClose;

  /// No description provided for @milkScreenEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get milkScreenEdit;

  /// No description provided for @milkScreenDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get milkScreenDelete;

  /// No description provided for @milkScreenLoadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more entries...'**
  String get milkScreenLoadingMore;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
