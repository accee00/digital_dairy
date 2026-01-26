import 'package:digital_dairy/core/bloc/app_config_bloc.dart';
import 'package:digital_dairy/core/di/init_di.dart';
import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

///
class ProfileScreen extends StatefulWidget {
  ///
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data - replace with actual user data from your state management
  final String userName = 'John Doe';
  final String userEmail = 'john.doe@example.com';
  final String userPhone = '+1 234 567 8900';
  final DateTime memberSince = DateTime(2023, 1, 15);

  // Settings states
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool smsNotifications = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScaffoldContainer(
      child: CustomScrollView(
        slivers: <Widget>[
          _appBar(context),

          // Profile Header Section
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                // Profile Picture
                CircleAvatar(
                  radius: 60,
                  backgroundColor: context.colorScheme.primary.withAlpha(200),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor:
                        context.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // User Name
                Text(userName, style: context.textTheme.headlineLarge),
                const SizedBox(height: 5),
                // Member Since
                Text(
                  'Member since ${_formatDate(memberSince)}',
                  style: context.textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Account Information Section
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
                _buildInfoTile(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: () {},
                  showTrailing: true,
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 15)),

          // Preferences Section
          SliverToBoxAdapter(
            child: BlocBuilder<AppConfigBloc, AppConfigState>(
              builder: (context, state) => _buildSection(
                title: 'Preferences',
                children: [
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

          // Notifications Section
          SliverToBoxAdapter(
            child: _buildSection(
              title: 'Notifications',
              children: [
                _buildSwitchTile(
                  icon: Icons.notifications_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Receive push notifications',
                  value: pushNotifications,
                  onChanged: (bool value) {
                    setState(() => pushNotifications = value);
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.email_outlined,
                  title: 'Email Notifications',
                  subtitle: 'Receive email updates',
                  value: emailNotifications,
                  onChanged: (bool value) {
                    setState(() => emailNotifications = value);
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.sms_outlined,
                  title: 'SMS Notifications',
                  subtitle: 'Receive text messages',
                  value: smsNotifications,
                  onChanged: (bool value) {
                    setState(() => smsNotifications = value);
                  },
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 15)),

          // Other Options Section
          SliverToBoxAdapter(
            child: _buildSection(
              title: 'Other',
              children: [
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

          // Logout Button
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
                    foregroundColor: context.colorScheme.onError,
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
        ],
      ),
    ),
  );

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
              _radioRow('Spanish', 'es', state.locale.languageCode),
              _radioRow('French', 'fr', state.locale.languageCode),
              _radioRow('German', 'de', state.locale.languageCode),
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
            onPressed: () {
              serviceLocator<AuthService>().logOutUser();
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
