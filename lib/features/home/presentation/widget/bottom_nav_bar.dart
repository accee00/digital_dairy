import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

/// A custom bottom navigation bar widget that uses the `GNav` package for navigation.
///
/// This widget creates a bottom navigation bar with predefined tabs and styling.
/// It requires the current selected index and a callback function to handle tab changes.
///
/// Parameters:
///   - `selectedIndex`: The index of the currently selected tab.
///   - `onTabChange`: A callback function that is called when a new tab is selected.
///     The function should take an integer as an argument representing the new selected index.
class CustomBottomNavBar extends StatelessWidget {
  /// Constructs a [CustomBottomNavBar].
  ///
  /// Requires [selectedIndex] to indicate the current active tab and [onTabChange]
  /// to handle tab selection changes.
  const CustomBottomNavBar({
    required this.selectedIndex,
    required this.onTabChange,
    super.key,
  });

  /// The current index of the selected tab.
  final int selectedIndex;

  /// Callback function to handle changes in tab selection.
  final void Function(int) onTabChange;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.colorScheme.surface,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: GNav(
        selectedIndex: selectedIndex,
        onTabChange: onTabChange,
        gap: 8,
        curve: Curves.easeInOutSine,
        activeColor: context.colorScheme.primary,
        iconSize: 24,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(milliseconds: 300),
        tabBackgroundColor: context.colorScheme.primary.withAlpha(90),
        color: context.colorScheme.onSurface,
        tabs: <GButton>[
          GButton(icon: Icons.home_rounded, text: context.strings.navbarHome),
          GButton(
            icon: Icons.local_drink_rounded,
            text: context.strings.navbarMilKLog,
          ),
          GButton(icon: Icons.pets_rounded, text: context.strings.navbarCattle),
          GButton(
            icon: Icons.assessment_rounded,
            text: context.strings.navbarReports,
          ),
        ],
      ),
    ),
  );
}
