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

  /// No description provided for @cattleEntryEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Cattle'**
  String get cattleEntryEdit;

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

  /// No description provided for @addCattleTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Cattle'**
  String get addCattleTitle;

  /// No description provided for @cattleBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get cattleBasicInfo;

  /// No description provided for @cattleNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Cattle Name *'**
  String get cattleNameLabel;

  /// No description provided for @cattleNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter cattle name (e.g., Ganga, Kamdhenu)'**
  String get cattleNameHint;

  /// No description provided for @tagIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag ID *'**
  String get tagIdLabel;

  /// No description provided for @tagIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter unique tag ID (e.g., C001, TAG123)'**
  String get tagIdHint;

  /// No description provided for @cattlePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Cattle Photo (Optional)'**
  String get cattlePhotoLabel;

  /// No description provided for @tapToAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to add photo'**
  String get tapToAddPhoto;

  /// No description provided for @physicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Physical Details'**
  String get physicalDetails;

  /// No description provided for @breedLabel.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breedLabel;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @importantDates.
  ///
  /// In en, this message translates to:
  /// **'Important Dates'**
  String get importantDates;

  /// No description provided for @dobLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dobLabel;

  /// No description provided for @calvingDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected Calving Date'**
  String get calvingDateLabel;

  /// No description provided for @calvingDateHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty if not applicable or unknown'**
  String get calvingDateHint;

  /// No description provided for @additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInfo;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesLabel;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Add any additional notes about this cattle...'**
  String get notesHint;

  /// No description provided for @saveCattleButton.
  ///
  /// In en, this message translates to:
  /// **'Save Cattle'**
  String get saveCattleButton;

  /// No description provided for @cattleNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Cattle name is required'**
  String get cattleNameRequired;

  /// No description provided for @tagIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Tag ID is required'**
  String get tagIdRequired;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @cattleRegisteredSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cattle registered successfully!'**
  String get cattleRegisteredSuccess;

  /// No description provided for @cattleUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cattle updated successfully!'**
  String get cattleUpdatedSuccess;

  /// No description provided for @failToUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image'**
  String get failToUploadImage;

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image:'**
  String get errorPickingImage;

  /// No description provided for @cattleDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cattle deleted successfully'**
  String get cattleDeletedSuccess;

  /// No description provided for @cattleDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting cattle'**
  String get cattleDeleteError;

  /// No description provided for @deleteCattle.
  ///
  /// In en, this message translates to:
  /// **'Delete Cattle'**
  String get deleteCattle;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this cattle? This action cannot be undone.'**
  String get deleteConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @breed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breed;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @currentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get currentStatus;

  /// No description provided for @monthlyMilk.
  ///
  /// In en, this message translates to:
  /// **'Monthly Milk'**
  String get monthlyMilk;

  /// No description provided for @expectedCalving.
  ///
  /// In en, this message translates to:
  /// **'Expected Calving'**
  String get expectedCalving;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @calvingDate.
  ///
  /// In en, this message translates to:
  /// **'Calving Date'**
  String get calvingDate;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @viewMilkProduction.
  ///
  /// In en, this message translates to:
  /// **'View Milk Production'**
  String get viewMilkProduction;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @pregnant.
  ///
  /// In en, this message translates to:
  /// **'Pregnant'**
  String get pregnant;

  /// No description provided for @sick.
  ///
  /// In en, this message translates to:
  /// **'Sick'**
  String get sick;

  /// No description provided for @dry.
  ///
  /// In en, this message translates to:
  /// **'Dry'**
  String get dry;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @dead.
  ///
  /// In en, this message translates to:
  /// **'Dead'**
  String get dead;

  /// No description provided for @myCattles.
  ///
  /// In en, this message translates to:
  /// **'My Cattles'**
  String get myCattles;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// No description provided for @found.
  ///
  /// In en, this message translates to:
  /// **'found'**
  String get found;

  /// No description provided for @cattleSingular.
  ///
  /// In en, this message translates to:
  /// **'Cattle'**
  String get cattleSingular;

  /// No description provided for @cattlePlural.
  ///
  /// In en, this message translates to:
  /// **'Cattles'**
  String get cattlePlural;

  /// No description provided for @failedToLoadCattle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cattle'**
  String get failedToLoadCattle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noCattleFound.
  ///
  /// In en, this message translates to:
  /// **'No cattle found'**
  String get noCattleFound;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @addFirstCattle.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add your first cattle'**
  String get addFirstCattle;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'mo'**
  String get months;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'y'**
  String get years;

  /// No description provided for @dailyRecords.
  ///
  /// In en, this message translates to:
  /// **'Daily Records'**
  String get dailyRecords;

  /// No description provided for @totalProduction.
  ///
  /// In en, this message translates to:
  /// **'Total Production'**
  String get totalProduction;

  /// No description provided for @dailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverage;

  /// No description provided for @daysRecorded.
  ///
  /// In en, this message translates to:
  /// **'Days Recorded'**
  String get daysRecorded;

  /// No description provided for @noMilkRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No milk records found'**
  String get noMilkRecordsFound;

  /// No description provided for @recordsWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Records for monthYear will appear here'**
  String get recordsWillAppear;

  /// No description provided for @previewPdf.
  ///
  /// In en, this message translates to:
  /// **'Preview PDF'**
  String get previewPdf;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @sharePdf.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get sharePdf;

  /// No description provided for @pdfSavedTo.
  ///
  /// In en, this message translates to:
  /// **'PDF saved to path'**
  String get pdfSavedTo;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @monthJanuary.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApril;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJune.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDecember;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get error;
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
