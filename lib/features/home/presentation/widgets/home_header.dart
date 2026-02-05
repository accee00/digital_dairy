import 'package:cached_network_image/cached_network_image.dart';
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

  String _getGreeting(BuildContext context) {
    final int hour = DateTime.now().hour;
    if (hour < 12) {
      return context.strings.goodMorning;
    }
    if (hour < 17) {
      return context.strings.goodAfternoon;
    }
    return context.strings.goodEvening;
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<ProfileCubit, ProfileState>(
    builder: (BuildContext context, ProfileState state) {
      String userName = context.strings.guest;
      String? profileImageUrl;

      // Extract user data from various success states
      if (state is FetchProfileSuccess) {
        userName = state.user.name;
        profileImageUrl = state.user.imageUrl;
      } else if (state is ProfileImageUploading) {
        userName = state.user.name;
        profileImageUrl = state.user.imageUrl;
      } else if (state is ProfileImageDeleting) {
        userName = state.user.name;
        profileImageUrl = state.user.imageUrl;
      } else if (state is ProfileImageUpdateSuccess) {
        userName = state.user.name;
        profileImageUrl = state.user.imageUrl;
      } else if (state is ProfileImageDeleteSuccess) {
        userName = state.user.name;
        profileImageUrl = state.user.imageUrl;
      } else if (state is ProfileImageUpdateFailure) {
        userName = state.user.name;
        profileImageUrl = state.user.imageUrl;
      } else if (state is ProfileImageDeleteFailure) {
        userName = state.user.name;
        profileImageUrl = state.user.imageUrl;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: <Widget>[
            // Profile Avatar with Gradient or Image
            GestureDetector(
              onTap: () => context.push(AppRoutes.profile),
              child: Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  gradient: profileImageUrl == null || profileImageUrl.isEmpty
                      ? const LinearGradient(
                          colors: AppTheme.primaryGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: context.colorScheme.primary.withAlpha(40),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: profileImageUrl != null && profileImageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: CachedNetworkImage(
                          imageUrl: profileImageUrl,
                          fit: BoxFit.cover,
                          placeholder: (BuildContext context, String url) =>
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: AppTheme.primaryGradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                          errorWidget:
                              (
                                BuildContext context,
                                String url,
                                Object error,
                              ) => Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: AppTheme.primaryGradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                        ),
                      )
                    : const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
              ),
            ),
            const SizedBox(width: 14),

            // Greeting & Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    _getGreeting(context),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: context.colorScheme.onSurface,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
