import 'package:digital_dairy/core/bloc/app_config_bloc.dart';
import 'package:digital_dairy/core/di/init_di.dart';
import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/features/home/cubit/profile_cubit.dart';
import 'package:digital_dairy/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: implementation_imports
import 'package:fpdart/src/either.dart';
import 'package:go_router/go_router.dart';

///
class ProfileScreen extends StatefulWidget {
  ///
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String defaultUserName = '';
  final String defaultUserEmail = '';
  final String defaultUserPhone = '';
  final DateTime defaultMemberSince = DateTime(2023, 1, 15);

  bool pushNotifications = false;
  bool emailNotifications = false;
  bool smsNotifications = false;

  @override
  void initState() {
    super.initState();

    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<ProfileCubit, ProfileState>(
        listener: (BuildContext context, ProfileState state) {},
        builder: (BuildContext context, ProfileState state) {
          final String userName = state is FetchProfileSuccess
              ? state.user.name
              : defaultUserName;
          final String userEmail = state is FetchProfileSuccess
              ? state.user.email
              : defaultUserEmail;
          final String userPhone = state is FetchProfileSuccess
              ? state.user.phoneNumber
              : defaultUserPhone;
          final DateTime memberSince =
              state is FetchProfileSuccess && state.user.createdAt != null
              ? state.user.createdAt!
              : defaultMemberSince;

          return Scaffold(
            body: CustomScaffoldContainer(
              child: CustomScrollView(
                slivers: <Widget>[
                  _appBar(context),

                  if (state is ProfileInitial)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),

                  if (state is FetchProfileFailure)
                    SliverFillRemaining(child: _buildErrorState(state.msg)),

                  if (state is! ProfileInitial && state is! FetchProfileFailure)
                    ..._buildContent(
                      context,
                      userName,
                      userEmail,
                      '+91 $userPhone',
                      memberSince,
                    ),
                ],
              ),
            ),
          );
        },
      );

  List<Widget> _buildContent(
    BuildContext context,
    String userName,
    String userEmail,
    String userPhone,
    DateTime memberSince,
  ) => <Widget>[
    SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundColor: context.colorScheme.primary.withAlpha(200),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: context.colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.person,
                size: 50,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 15),

          Text(userName, style: context.textTheme.headlineLarge),
          const SizedBox(height: 5),

          Text(
            'Member since ${_formatDate(memberSince)}',
            style: context.textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),

    SliverToBoxAdapter(
      child: _buildSection(
        title: 'Account Information',
        children: <Widget>[
          _buildInfoTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: userEmail,
            onTap: () {},
          ),
          _buildInfoTile(
            icon: Icons.phone_outlined,
            title: 'Phone Number',
            subtitle: userPhone,
            onTap: () {},
          ),
        ],
      ),
    ),

    const SliverToBoxAdapter(child: SizedBox(height: 15)),

    SliverToBoxAdapter(
      child: BlocBuilder<AppConfigBloc, AppConfigState>(
        builder: (BuildContext context, AppConfigState state) => _buildSection(
          title: 'Preferences',
          children: <Widget>[
            _buildInfoTile(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: _getLanguageName(state.locale.languageCode),
              onTap: () => _showLocaleDialog(state),
              showTrailing: true,
            ),
            _buildThemeModeTile(
              icon: Icons.brightness_6_outlined,
              title: 'Theme',
              currentThemeMode: state.themeMode,
              onChanged: (ThemeMode mode) {
                context.read<AppConfigBloc>().add(ThemeChangeEvent(mode));
              },
            ),
          ],
        ),
      ),
    ),

    const SliverToBoxAdapter(child: SizedBox(height: 15)),

    SliverToBoxAdapter(
      child: _buildSection(
        title: 'Notifications',
        children: <Widget>[
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Receive push notifications',
            value: pushNotifications,
            onChanged: (bool value) {
              showAppSnackbar(context, message: 'This feature will come soon.');
              return;
              // setState(() => pushNotifications = value);
            },
          ),
          _buildSwitchTile(
            icon: Icons.email_outlined,
            title: 'Email Notifications',
            subtitle: 'Receive email updates',
            value: emailNotifications,
            onChanged: (bool value) {
              showAppSnackbar(context, message: 'This feature will come soon.');
              return;
              // setState(() => emailNotifications = value);
            },
          ),
          _buildSwitchTile(
            icon: Icons.sms_outlined,
            title: 'SMS Notifications',
            subtitle: 'Receive text messages',
            value: smsNotifications,
            onChanged: (bool value) {
              showAppSnackbar(context, message: 'This feature will come soon.');
              return;
              // setState(() => smsNotifications = value);
            },
          ),
        ],
      ),
    ),

    const SliverToBoxAdapter(child: SizedBox(height: 15)),

    SliverToBoxAdapter(
      child: _buildSection(
        title: 'Other',
        children: <Widget>[
          _buildInfoTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {},
            showTrailing: true,
          ),
          _buildInfoTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            onTap: () {},
            showTrailing: true,
          ),
          _buildInfoTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
            showTrailing: true,
          ),
          _buildInfoTile(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () {},
            showTrailing: true,
          ),
        ],
      ),
    ),

    const SliverToBoxAdapter(child: SizedBox(height: 15)),

    SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    ),

    const SliverToBoxAdapter(child: SizedBox(height: 30)),
  ];

  Widget _buildErrorState(String errorMessage) {
    final bool isUserNotFound =
        errorMessage.toLowerCase().contains('user not found') ||
        errorMessage.toLowerCase().contains('user not signed in');

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            isUserNotFound ? Icons.person_off : Icons.error_outline,
            size: 64,
            color: context.colorScheme.error,
          ),
          const SizedBox(height: 20),
          Text(
            isUserNotFound ? 'User Not Found' : 'Error Loading Profile',
            style: context.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            errorMessage,
            style: context.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          if (isUserNotFound)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showLogoutDialog,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.error,
                  foregroundColor: context.colorScheme.onError,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () {
                context.read<ProfileCubit>().fetchProfile();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  SliverAppBar _appBar(BuildContext context) => SliverAppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Container(
      height: 43,
      width: 43,
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: const EdgeInsets.only(left: 10),
        onPressed: () => context.pop(),
        icon: Icon(Icons.arrow_back_ios, color: context.colorScheme.onSurface),
      ),
    ),
    title: Text(
      'Profile',
      style: context.textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.colorScheme.onSurface,
      ),
    ),
  );

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(title, style: context.textTheme.titleLarge),
      ),
      const SizedBox(height: 8),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: children),
      ),
    ],
  );

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool showTrailing = false,
  }) => ListTile(
    leading: Icon(icon, color: context.colorScheme.primary.withAlpha(200)),
    title: Text(title, style: context.textTheme.bodyLarge),
    subtitle: subtitle != null
        ? Text(
            subtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          )
        : null,
    trailing: showTrailing
        ? Icon(
            Icons.chevron_right,
            color: context.colorScheme.onSurfaceVariant.withAlpha(102),
          )
        : null,
    onTap: onTap,
  );

  Widget _buildThemeModeTile({
    required IconData icon,
    required String title,
    required ThemeMode currentThemeMode,
    required ValueChanged<ThemeMode> onChanged,
  }) => ListTile(
    leading: Icon(icon, color: context.colorScheme.primary.withAlpha(200)),
    title: Text(title, style: context.textTheme.bodyLarge),
    subtitle: Text(
      _getThemeModeName(currentThemeMode),
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
      ),
    ),
    trailing: Icon(
      Icons.chevron_right,
      color: context.colorScheme.onSurfaceVariant.withAlpha(102),
    ),
    onTap: () => _showThemeModeDialog(currentThemeMode, onChanged),
  );

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
  }) => SwitchListTile(
    secondary: Icon(icon, color: context.colorScheme.primary.withAlpha(200)),
    title: Text(title, style: context.textTheme.bodyLarge),
    subtitle: subtitle != null
        ? Text(
            subtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          )
        : null,
    value: value,
    onChanged: onChanged,
    activeThumbColor: context.colorScheme.primary,
  );

  String _formatDate(DateTime date) {
    final List<String> months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      case 'de':
        return 'German';
      case 'hi':
        return 'Hindi';
      default:
        return 'English';
    }
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  void _showLocaleDialog(AppConfigState state) {
    showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Language'),
        content: RadioGroup<String>(
          groupValue: state.locale.languageCode,
          onChanged: (String? value) {
            if (value != null) {
              context.read<AppConfigBloc>().add(
                LocaleChangeEvent(Locale(value), hasShownLanguageDialog: true),
              );
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _radioRow('English', 'en', state.locale.languageCode),
              _radioRow('Hindi', 'hi', state.locale.languageCode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _radioRow(String label, String value, String groupValue) => ListTile(
    leading: Radio<String>(value: value),
    title: Text(label),
  );

  Widget _themeRadioRow(String label, ThemeMode value, ThemeMode groupValue) =>
      ListTile(
        leading: Radio<ThemeMode>(value: value),
        title: Text(label),
      );

  void _showThemeModeDialog(
    ThemeMode currentMode,
    ValueChanged<ThemeMode> onChanged,
  ) {
    showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Theme'),
        content: RadioGroup<ThemeMode>(
          groupValue: currentMode,
          onChanged: (ThemeMode? value) {
            if (value != null) {
              onChanged(value);
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _themeRadioRow('Light', ThemeMode.light, currentMode),
              _themeRadioRow('Dark', ThemeMode.dark, currentMode),
              _themeRadioRow('System Default', ThemeMode.system, currentMode),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final Either<Failure, bool> response =
                  await serviceLocator<AuthService>().logOutUser();
              response.fold(
                (Failure failure) {
                  showAppSnackbar(context, message: failure.message);
                  Navigator.pop(context);
                },
                (bool value) {
                  context.pushReplacementNamed(AppRoutes.signUp);
                },
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(color: context.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
