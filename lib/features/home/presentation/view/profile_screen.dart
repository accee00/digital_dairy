import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
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
  String selectedLocale = 'English';
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Picture
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 47,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // User Name
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Member Since
                  Text(
                    'Member since ${_formatDate(memberSince)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Account Information Section
            _buildSection(
              title: 'Account Information',
              children: [
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

            const SizedBox(height: 15),

            // Preferences Section
            _buildSection(
              title: 'Preferences',
              children: [
                _buildInfoTile(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: selectedLocale,
                  onTap: () => _showLocaleDialog(),
                  showTrailing: true,
                ),
                _buildSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() => isDarkMode = value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Notifications Section
            _buildSection(
              title: 'Notifications',
              children: [
                _buildSwitchTile(
                  icon: Icons.notifications_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Receive push notifications',
                  value: pushNotifications,
                  onChanged: (value) {
                    setState(() => pushNotifications = value);
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.email_outlined,
                  title: 'Email Notifications',
                  subtitle: 'Receive email updates',
                  value: emailNotifications,
                  onChanged: (value) {
                    setState(() => emailNotifications = value);
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.sms_outlined,
                  title: 'SMS Notifications',
                  subtitle: 'Receive text messages',
                  value: smsNotifications,
                  onChanged: (value) {
                    setState(() => smsNotifications = value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Other Options Section
            _buildSection(
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

            const SizedBox(height: 15),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool showTrailing = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            )
          : null,
      trailing: showTrailing
          ? Icon(Icons.chevron_right, color: Colors.grey[400])
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            )
          : null,
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
    );
  }

  String _formatDate(DateTime date) {
    final months = [
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

  void _showLocaleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLocaleOption('English'),
            _buildLocaleOption('Spanish'),
            _buildLocaleOption('French'),
            _buildLocaleOption('German'),
            _buildLocaleOption('Hindi'),
          ],
        ),
      ),
    );
  }

  Widget _buildLocaleOption(String locale) {
    return RadioListTile<String>(
      title: Text(locale),
      value: locale,
      groupValue: selectedLocale,
      onChanged: (value) {
        setState(() => selectedLocale = value!);
        Navigator.pop(context);
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Add logout logic here
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
