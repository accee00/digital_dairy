import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/features/cattle/presentation/view/add_cattle_screen.dart';
import 'package:digital_dairy/features/cattle/presentation/view/cattle_screen.dart';
import 'package:digital_dairy/features/home/presentation/view/home_scree.dart';
import 'package:digital_dairy/features/home/presentation/widget/bottom_nav_bar.dart';
import 'package:digital_dairy/features/milklog/presentation/view/milk_log_screen.dart';
import 'package:flutter/material.dart';

/// A StatefulWidget for the main screen of the application.
///
/// This class represents the main screen and manages its state through
/// [_MainScreenState].
class MainScreen extends StatefulWidget {
  /// Creates an instance of [MainScreen].
  ///
  /// Optionally includes a key for the widget.
  const MainScreen({super.key});

  /// Creates the mutable state for this widget at a given location in the tree.
  ///
  /// Returns an instance of [_MainScreenState].
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = <Widget>[
    const HomeScreen(),
    const MilkLogScreen(),
    const CattleScreen(),
    const Center(child: Text('data')),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),

      extendBody: true,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colorScheme.primary.withAlpha(100),
              colorScheme.surface,
              colorScheme.secondary.withAlpha(90),
            ],
          ),
        ),
        child: IndexedStack(index: _selectedIndex, children: _screens),
      ),
    );
  }
}
