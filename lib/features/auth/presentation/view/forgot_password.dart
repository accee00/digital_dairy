import 'package:digital_dairy/core/extension/build_extenstion.dart';

import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/widget/custom_circular_indicator.dart';
import 'package:digital_dairy/core/widget/custom_container.dart';
import 'package:digital_dairy/core/widget/custom_text_feild.dart';
import 'package:digital_dairy/core/widget/elevated_button.dart';
import 'package:digital_dairy/features/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A StatefulWidget for handling the forgot password process.
class ForgotPasswordPage extends StatefulWidget {
  /// Initializes [key] for [ForgotPasswordPage] widget.
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await context.read<AuthCubit>().forgotPassword(
      email: _emailController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return context.strings.authInvalidEmail;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return context.strings.authInvalidEmail;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final TextTheme textTheme = context.textTheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthForgotPassFailure) {}
        if (state is AuthForgotPassSuccess) {
          showAppSnackbar(
            context,
            message: context.strings.authResetLinkSent,
            type: SnackbarType.success,
          );
          context.pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            // Main content
            CustomContainer(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 10),

                        // Back button
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: colorScheme.onPrimary,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: colorScheme.primary.withAlpha(150),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Forgot Password Icon
                        Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.primary.withAlpha(20),
                              border: Border.all(
                                color: colorScheme.primary.withAlpha(50),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.lock_reset_rounded,
                              size: 50,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Forgot Password text
                        Center(
                          child: Text(
                            context.strings.authForgotPassword,
                            style: textTheme.displaySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Description text
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              context.strings.authForgotPasswordDescription,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface.withAlpha(140),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Email field
                        CustomTextField(
                          controller: _emailController,
                          hintText: context.strings.authEnterEmail,
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          textInputAction: TextInputAction.done,
                        ),

                        const SizedBox(height: 30),

                        // Send Reset Link Button
                        SizedBox(
                          width: double.infinity,
                          child: CustomElevatedButton(
                            onPressed: _handleForgotPassword,
                            text: context.strings.authSendResetLink,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Remember password section
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                context.strings.authRememberPassword,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(150),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => context.pop(),
                                  child: Text(
                                    maxLines: 1,
                                    context.strings.authBackToSignIn,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Additional help section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withAlpha(10),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.primary.withAlpha(30),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.info_outline_rounded,
                                color: colorScheme.primary,
                                size: 24,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                context.strings.authResetPasswordHelp,
                                textAlign: TextAlign.center,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(120),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (_isLoading) const CustomLoadingIndicator.overlay(),
          ],
        ),
      ),
    );
  }
}
