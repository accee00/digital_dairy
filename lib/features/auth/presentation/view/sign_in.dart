import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/features/auth/presentation/widget/custom_text_feild.dart';
import 'package:digital_dairy/features/auth/presentation/widget/elevated_button.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network delay
      await Future<void>.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        showAppSnackbar(
          context,
          message: context.strings.authSignIn,
          type: SnackbarType.error,
        );
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final TextTheme textTheme = context.textTheme;

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colorScheme.primary.withAlpha(100),
              colorScheme.surface,
              colorScheme.secondary.withAlpha(90),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Back button
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
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

                  // Welcome text
                  Text(
                    context.strings.authWelcomeBack,
                    style: textTheme.displaySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Subtitle
                  Text(
                    'Please sign in to your account',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
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
                  ),

                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: _passwordController,
                    hintText: context.strings.authEnterPassword,
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    validator: _validatePassword,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: colorScheme.onSurface.withAlpha(120),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        context.strings.authForgotPassword,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      onPressed: _isLoading ? null : _handleSignIn,
                      text: _isLoading ? 'Signing In...' : 'Sign In',
                    ),
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withAlpha(150),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            context.strings.authSignUp,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
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
    );
  }
}
