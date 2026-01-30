import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/widget/custom_circular_indicator.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/custom_text_feild.dart';
import 'package:digital_dairy/core/widget/elevated_button.dart';
import 'package:digital_dairy/features/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A page that allows users to request a password reset email.
class ForgotPasswordPage extends StatefulWidget {
  /// Creates a [ForgotPasswordPage].
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

    setState(() => _isLoading = true);
    await context.read<AuthCubit>().forgotPassword(
      email: _emailController.text.trim(),
    );
    setState(() => _isLoading = false);
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
        if (state is AuthForgotPassSuccess) {
          showAppSnackbar(
            context,
            message: context.strings.authResetLinkSent,
            type: SnackbarType.success,
          );
          context.pop();
        }
        if (state is AuthForgotPassFailure) {
          showAppSnackbar(
            context,
            message: state.msg,
            type: SnackbarType.success,
          );
          context.pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            CustomScaffoldContainer(
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
                        Container(
                          decoration: BoxDecoration(
                            color: context.colorScheme.surface,
                            shape: BoxShape.circle,
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.only(left: 10),
                            onPressed: () => context.pop(),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Forgot Password text
                        Text(
                          context.strings.authForgotPassword,
                          style: textTheme.displaySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Description text
                        Text(
                          context.strings.authForgotPasswordDescription,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withAlpha(140),
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 20),

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
