import 'package:digital_dairy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide easy access to commonly used properties.
extension BuildContextExtension on BuildContext {
  /// Retrieves the [ThemeData] associated with the closest [Theme] widget that encloses the given context.
  ThemeData get themeData => Theme.of(this);

  /// Checks if the current theme's brightness is dark.
  bool get isDarkMode => themeData.brightness == Brightness.dark;

  /// Checks if the current theme's brightness is light.
  bool get isLightMode => themeData.brightness == Brightness.light;

  /// Returns the localized [AppLocalizations] instance for the current context.
  /// Throws an exception if no [AppLocalizations] is found.
  AppLocalizations get strings => AppLocalizations.of(this)!;

  /// Retrieves the current [ColorScheme] from the closest [Theme] widget that encloses the given context.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Retrieves the current [TextTheme] from the closest [Theme] widget that encloses the given context.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Returns the size of the media (e.g., screen) accessible from the given context.
  Size get size => MediaQuery.of(this).size;

  /// Returns the width of the current screen or media query context.
  double get width => size.width;

  /// Returns the height of the current screen or media query context.
  double get height => size.height;
}
