import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/theme/app_theme.dart';
import 'package:digital_dairy/features/home/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Header widget for the home screen, displaying user profile and notifications.
class HomeHeader extends StatelessWidget {
  /// Creates a [HomeHeader].
  const HomeHeader({super.key});

  String _getGreeting() {
    final int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    }
    if (hour < 17) {
      return 'Good Afternoon,';
    }
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<ProfileCubit, ProfileState>(
    builder: (BuildContext context, ProfileState state) {
      final String userName = (state is FetchProfileSuccess)
          ? state.user.name
          : 'Guest';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: <Widget>[
            // Profile Avatar with Gradient
            GestureDetector(
              onTap: () => context.push(AppRoutes.profile),
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppTheme.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: context.colorScheme.primary.withAlpha(40),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Greeting & Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _getGreeting(),
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    userName,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: context.colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Notifications with subtle badge indicator
            Stack(
              children: <Widget>[
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: context.colorScheme.outlineVariant.withAlpha(150),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: context.colorScheme.onSurface,
                    size: 26,
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colorScheme.surface,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
