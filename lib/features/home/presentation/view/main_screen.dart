import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/features/auth/cubit/auth_cubit.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/cattle/presentation/view/cattle_screen.dart';
import 'package:digital_dairy/features/home/cubit/analytics_cubit.dart';
import 'package:digital_dairy/features/home/cubit/profile_cubit.dart';
import 'package:digital_dairy/features/home/presentation/view/home_screen.dart';
import 'package:digital_dairy/features/home/presentation/widgets/bottom_nav_bar.dart';
import 'package:digital_dairy/features/milklog/cubit/milk_cubit.dart';
import 'package:digital_dairy/features/milklog/presentation/view/milk_log_screen.dart';
import 'package:digital_dairy/features/sales/cubit/sales_cubit.dart';
import 'package:digital_dairy/features/sales/presentation/milk_sales_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    const MilkScreen(),
    const CattleScreen(),
    const MilkSalesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    return BlocListener<AuthCubit, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthSuccessState) {
          context.read<ProfileCubit>().fetchProfile();
          context.read<AnalyticsCubit>().fetchAnalytics();
          context.read<CattleCubit>().getCattle();
          context.read<MilkCubit>().getMilkLog();
          context.read<SalesCubit>().getBuyers();
        }
      },
      child: Scaffold(
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
                colorScheme.secondary.withAlpha(100),
                colorScheme.primary.withAlpha(160),
                colorScheme.secondary.withAlpha(80),
              ],
            ),
          ),
          child: IndexedStack(index: _selectedIndex, children: _screens),
        ),
      ),
    );
  }
}
