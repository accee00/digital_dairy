import 'package:digital_dairy/core/bloc/app_config_bloc.dart';
import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/widget/custom_circular_indicator.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/custom_text_feild.dart';
import 'package:digital_dairy/core/widget/elevated_button.dart';
import 'package:digital_dairy/features/auth/cubit/auth_cubit.dart';
import 'package:digital_dairy/features/auth/presentation/widget/language_selection_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

///
class SignUpPage extends StatefulWidget {
  ///
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final AppConfigState localeState = context.read<AppConfigBloc>().state;

      if (!localeState.hasShownLanguageDialog) {
        showLanguageSelectionDialog(context: context);
        context.read<AppConfigBloc>().add(
          LocaleChangeEvent(localeState.locale, hasShownLanguageDialog: true),
        );
      }
    });
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_acceptTerms) {
      _showErrorSnackBar(
        context.strings.authAgreeTerms.trim() +
            context.strings.authTermsConditions,
      );
      return;
    }
    await context.read<AuthCubit>().signUpUser(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  void _showErrorSnackBar(String message) {
    showAppSnackbar(context, message: message);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return context.strings.authEmailRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return context.strings.authInvalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.strings.authPasswordRequired;
    }
    if (value.length < 6) {
      return context.strings.authInvalidPassword;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.strings.authConfirmPasswordRequired;
    }
    if (value != _passwordController.text) {
      return context.strings.authPasswordsDoNotMatch;
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return context.strings.authInvalidPhone;
    }
    if (!RegExp(r'^\+?[1-9]\d{9,14}$').hasMatch(value.replaceAll(' ', ''))) {
      return context.strings.authInvalidPhone;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final TextTheme textTheme = context.textTheme;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthSuccessState) {
          showAppSnackbar(context, message: context.strings.authWelcome);
          context.go(AppRoutes.home);
        }
        if (state is AuthFailureState) {
          showAppSnackbar(
            context,
            message: state.msg,
            type: SnackbarType.error,
          );
        }
      },
      builder: (BuildContext context, AuthState state) => Scaffold(
        body: Stack(
          children: <Widget>[
            CustomScaffoldContainer(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverSafeArea(
                    sliver: SliverPadding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 25,
                        top: 10,
                        bottom: 20,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(<Widget>[
                          // Heading and Subheading
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                context.strings.authCreateAccount,
                                style: textTheme.displayLarge?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                context.strings.welcome,
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(180),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // Form
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                // Name Field
                                CustomTextField(
                                  controller: _nameController,
                                  labelText: context.strings.authName,
                                  hintText: context.strings.authEnterName,
                                  prefixIcon: Icons.person_outline_rounded,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return context.strings.authNameRequires;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),

                                // Email Field
                                CustomTextField(
                                  controller: _emailController,
                                  labelText: context.strings.authEmail,
                                  hintText: context.strings.authEnterEmail,
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                ),
                                const SizedBox(height: 15),

                                // Phone Field
                                CustomTextField(
                                  controller: _phoneController,
                                  labelText: context.strings.authPhone,
                                  hintText: context.strings.authEnterPhone,
                                  prefixIcon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  validator: _validatePhone,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9+\-\s]'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                // Password Field
                                CustomTextField(
                                  controller: _passwordController,
                                  labelText: context.strings.authPassword,
                                  hintText: context.strings.authEnterPassword,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: !_isPasswordVisible,
                                  validator: _validatePassword,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: colorScheme.onSurface.withAlpha(
                                        120,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Confirm Password Field
                                CustomTextField(
                                  controller: _confirmPasswordController,
                                  labelText:
                                      context.strings.authConfirmPassword,
                                  hintText: context.strings.authConfirmPassword,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: !_isConfirmPasswordVisible,
                                  validator: _validateConfirmPassword,
                                  textInputAction: TextInputAction.done,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmPasswordVisible =
                                            !_isConfirmPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _isConfirmPasswordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: colorScheme.onSurface.withAlpha(
                                        120,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),

                                // Terms and Conditions
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: _acceptTerms,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _acceptTerms = value ?? false;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.onSurface
                                                .withAlpha(180),
                                          ),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: context
                                                  .strings
                                                  .authAgreeTerms,
                                            ),
                                            TextSpan(
                                              text: context
                                                  .strings
                                                  .authTermsConditions,
                                              style: TextStyle(
                                                color: colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                            const TextSpan(text: ' and '),
                                            TextSpan(
                                              text: context
                                                  .strings
                                                  .authPrivacyPolicy,
                                              style: TextStyle(
                                                color: colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),

                                // Sign Up Button
                                CustomElevatedButton(
                                  onPressed: _handleSignUp,
                                  text: context.strings.authCreateAccountAction,
                                  icon: Icons.person_add_rounded,
                                ),
                                const SizedBox(height: 20),

                                // Or divider
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Divider(
                                        color: colorScheme.onSurface.withAlpha(
                                          40,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        context.strings.authOr,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurface
                                              .withAlpha(180),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: colorScheme.onSurface.withAlpha(
                                          40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // // Social Sign Up Buttons
                                // Row(
                                //   children: <Widget>[
                                //     Expanded(
                                //       child: CustomElevatedButton(
                                //         onPressed: () {},
                                //         text: context.strings.authWithGoogle,
                                //         icon: Icons.g_mobiledata_rounded,
                                //         isOutlined: true,
                                //       ),
                                //     ),
                                //     const SizedBox(width: 16),
                                //     Expanded(
                                //       child: CustomElevatedButton(
                                //         onPressed: () {},
                                //         text: context.strings.authWithApple,
                                //         icon: Icons.apple_rounded,
                                //         isOutlined: true,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // const SizedBox(height: 20),

                                // Already have an account
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.onSurface.withAlpha(
                                          150,
                                        ),
                                      ),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: context
                                              .strings
                                              .authAlreadyHaveAccount,
                                        ),
                                        WidgetSpan(
                                          child: GestureDetector(
                                            onTap: () =>
                                                context.push(AppRoutes.signIn),
                                            child: Text(
                                              context.strings.authSignIn,
                                              style: textTheme.bodyLarge
                                                  ?.copyWith(
                                                    color: colorScheme.primary,
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state is AuthLoading) const CustomLoadingIndicator.overlay(),
          ],
        ),
      ),
    );
  }
}
