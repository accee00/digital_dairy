import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:digital_dairy/core/bloc/app_config_bloc.dart';
import 'package:digital_dairy/core/di/init_di.dart';
import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/features/auth/model/user.dart';
import 'package:digital_dairy/features/home/cubit/profile_cubit.dart';
import 'package:digital_dairy/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' show Either;
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

///
class ProfileScreen extends StatefulWidget {
  ///
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DateTime defaultMemberSince = DateTime(2023, 1, 15);

  bool pushNotifications = false;
  bool emailNotifications = false;
  bool smsNotifications = false;

  final ImagePicker _imagePicker = ImagePicker();

  late UserModel? currentUser;
  bool isImageLoading = false;

  @override
  void initState() {
    super.initState();
    currentUser = null;
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocConsumer<ProfileCubit, ProfileState>(
    listener: (BuildContext context, ProfileState state) {
      if (state is FetchProfileSuccess) {
        currentUser = state.user;
        isImageLoading = false;
      }

      if (state is ProfileImageUploading) {
        currentUser = state.user;
        isImageLoading = true;
      }

      if (state is ProfileImageDeleting) {
        currentUser = state.user;
        isImageLoading = true;
      }

      if (state is ProfileImageUpdateSuccess) {
        currentUser = state.user;
        showAppSnackbar(context, message: context.strings.profileImageUpdated);
      }

      if (state is ProfileImageUpdateFailure) {
        currentUser = state.user;
        isImageLoading = false;
        showAppSnackbar(context, message: state.message);
      }

      if (state is ProfileImageDeleteSuccess) {
        currentUser = state.user;
        showAppSnackbar(context, message: context.strings.profileImageDeleted);
      }

      if (state is ProfileImageDeleteFailure) {
        currentUser = state.user;
        isImageLoading = false;
        showAppSnackbar(context, message: state.message);
      }
    },
    builder: (BuildContext context, ProfileState state) => Scaffold(
      body: CustomScaffoldContainer(
        child: CustomScrollView(
          slivers: <Widget>[
            _appBar(context),

            if (state is ProfileInitial ||
                (state is ProfileLoading && currentUser == null))
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state is FetchProfileFailure && currentUser == null)
              SliverFillRemaining(child: _buildErrorState(state.message))
            else if (currentUser != null)
              ..._buildContent(
                context,
                currentUser!.name,
                currentUser!.email,
                '+91 ${currentUser!.phoneNumber}',
                currentUser!.createdAt ?? defaultMemberSince,
                currentUser!.imageUrl,
              ),
          ],
        ),
      ),
    ),
  );

  List<Widget> _buildContent(
    BuildContext context,
    String userName,
    String userEmail,
    String userPhone,
    DateTime memberSince,
    String? profileImageUrl,
  ) => <Widget>[
    SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          _buildProfileAvatar(profileImageUrl),
          const SizedBox(height: 15),
          Text(userName, style: context.textTheme.headlineLarge),
          const SizedBox(height: 5),
          Text(
            '${context.strings.profileMemberSince} ${_formatDate(memberSince)}',
            style: context.textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),

    SliverToBoxAdapter(
      child: _buildSection(
        title: context.strings.profileAccountInformation,
        children: <Widget>[
          _buildInfoTile(
            icon: Icons.email_outlined,
            title: context.strings.profileEmail,
            subtitle: userEmail,
            onTap: () {},
          ),
          _buildInfoTile(
            icon: Icons.phone_outlined,
            title: context.strings.profilePhoneNumber,
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
          title: context.strings.profilePreferences,
          children: <Widget>[
            _buildInfoTile(
              icon: Icons.language_outlined,
              title: context.strings.profileLanguage,
              subtitle: _getLanguageName(state.locale.languageCode, context),
              onTap: () => _showLocaleDialog(state),
              showTrailing: true,
            ),
            _buildThemeModeTile(
              icon: Icons.brightness_6_outlined,
              title: context.strings.profileTheme,
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
        title: context.strings.profileNotifications,
        children: <Widget>[
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: context.strings.profilePushNotifications,
            subtitle: context.strings.profileReceivePushNotifications,
            value: pushNotifications,
            onChanged: (bool value) {
              showAppSnackbar(
                context,
                message: context.strings.profileFeatureComingSoon,
              );
              return;
            },
          ),
          _buildSwitchTile(
            icon: Icons.email_outlined,
            title: context.strings.profileEmailNotifications,
            subtitle: context.strings.profileReceiveEmailUpdates,
            value: emailNotifications,
            onChanged: (bool value) {
              showAppSnackbar(
                context,
                message: context.strings.profileFeatureComingSoon,
              );
              return;
            },
          ),
          _buildSwitchTile(
            icon: Icons.sms_outlined,
            title: context.strings.profileSMSNotifications,
            subtitle: context.strings.profileReceiveTextMessages,
            value: smsNotifications,
            onChanged: (bool value) {
              showAppSnackbar(
                context,
                message: context.strings.profileFeatureComingSoon,
              );
              return;
            },
          ),
        ],
      ),
    ),

    const SliverToBoxAdapter(child: SizedBox(height: 15)),

    SliverToBoxAdapter(
      child: _buildSection(
        title: context.strings.profileOther,
        children: <Widget>[
          _buildInfoTile(
            icon: Icons.privacy_tip_outlined,
            title: context.strings.profilePrivacyPolicy,
            onTap: () {},
            showTrailing: true,
          ),
          _buildInfoTile(
            icon: Icons.description_outlined,
            title: context.strings.profileTermsConditions,
            onTap: () {},
            showTrailing: true,
          ),
          _buildInfoTile(
            icon: Icons.help_outline,
            title: context.strings.profileHelpSupport,
            onTap: () {},
            showTrailing: true,
          ),
          _buildInfoTile(
            icon: Icons.info_outline,
            title: context.strings.profileAbout,
            subtitle: context.strings.profileVersion,
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
            label: Text(context.strings.profileLogout),
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
    ),

    const SliverToBoxAdapter(child: SizedBox(height: 30)),
  ];

  Widget _buildProfileAvatar(String? profileImageUrl) => Stack(
    children: <Widget>[
      CircleAvatar(
        radius: 55,
        backgroundColor: context.colorScheme.surfaceContainerHighest,
        backgroundImage: profileImageUrl != null && profileImageUrl.isNotEmpty
            ? CachedNetworkImageProvider(profileImageUrl)
            : null,
        child: profileImageUrl == null || profileImageUrl.isEmpty
            ? Icon(
                Icons.person,
                size: 50,
                color: context.colorScheme.onSurfaceVariant,
              )
            : null,
      ),

      if (isImageLoading)
        const Positioned.fill(
          child: CircleAvatar(radius: 55, child: CircularProgressIndicator()),
        ),

      Positioned(
        bottom: 0,
        right: 0,
        child: GestureDetector(
          onTap: isImageLoading
              ? null
              : () => _showImageOptions(profileImageUrl),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: context.colorScheme.primary,
            child: Icon(
              profileImageUrl == null || profileImageUrl.isEmpty
                  ? Icons.add_a_photo
                  : Icons.edit,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );

  void _showImageOptions(String? currentImageUrl) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext bottomSheetContext) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(context.strings.profileTakePhoto),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(context.strings.profileChooseGallery),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (currentImageUrl != null && currentImageUrl.isNotEmpty)
              ListTile(
                leading: Icon(Icons.delete, color: context.colorScheme.error),
                title: Text(
                  context.strings.profileDeletePhoto,
                  style: TextStyle(color: context.colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _deleteProfileImage();
                },
              ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: Text(context.strings.profileCancel),
              onTap: () => Navigator.pop(bottomSheetContext),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        if (!mounted) {
          return;
        }
        await context.read<ProfileCubit>().updateProfileImage(image: imageFile);
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      showAppSnackbar(
        context,
        message: '${context.strings.errorPickingImage} ${e.toString()}',
      );
    }
  }

  void _deleteProfileImage() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(context.strings.profileDeletePhotoTitle),
        content: Text(context.strings.profileDeletePhotoConfirmation),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.strings.profileCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ProfileCubit>().deleteProfileImage();
            },
            child: Text(
              context.strings.delete,
              style: TextStyle(color: context.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

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
            isUserNotFound
                ? context.strings.profileUserNotFound
                : context.strings.profileErrorLoading,
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
                label: Text(context.strings.profileLogout),
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
              label: Text(context.strings.retry),
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
      context.strings.profileTitle,
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
      _getThemeModeName(currentThemeMode, context),
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
      context.strings.monthJanuary,
      context.strings.monthFebruary,
      context.strings.monthMarch,
      context.strings.monthApril,
      context.strings.monthMay,
      context.strings.monthJune,
      context.strings.monthJuly,
      context.strings.monthAugust,
      context.strings.monthSeptember,
      context.strings.monthOctober,
      context.strings.monthNovember,
      context.strings.monthDecember,
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getLanguageName(String languageCode, BuildContext context) {
    switch (languageCode) {
      case 'en':
        return context.strings.profileLanguageEnglish;
      case 'hi':
        return context.strings.profileLanguageHindi;
      default:
        return context.strings.profileLanguageEnglish;
    }
  }

  String _getThemeModeName(ThemeMode mode, BuildContext context) {
    switch (mode) {
      case ThemeMode.light:
        return context.strings.profileLight;
      case ThemeMode.dark:
        return context.strings.profileDark;
      case ThemeMode.system:
        return context.strings.profileSystemDefault;
    }
  }

  void _showLocaleDialog(AppConfigState state) {
    showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.strings.profileSelectLanguage),
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
              _radioRow(
                context.strings.profileLanguageEnglish,
                'en',
                state.locale.languageCode,
              ),
              _radioRow(
                context.strings.profileLanguageHindi,
                'hi',
                state.locale.languageCode,
              ),
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

  Widget _themeRadioRow(
    String label,
    ThemeMode value,
    ThemeMode groupValue,
    BuildContext context,
  ) => ListTile(
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
        title: Text(context.strings.profileSelectTheme),
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
              _themeRadioRow(
                context.strings.profileLight,
                ThemeMode.light,
                currentMode,
                context,
              ),
              _themeRadioRow(
                context.strings.profileDark,
                ThemeMode.dark,
                currentMode,
                context,
              ),
              _themeRadioRow(
                context.strings.profileSystemDefault,
                ThemeMode.system,
                currentMode,
                context,
              ),
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
        title: Text(context.strings.profileLogout),
        content: Text(context.strings.profileLogoutConfirmation),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.strings.profileCancel),
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
              context.strings.profileLogout,
              style: TextStyle(color: context.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
