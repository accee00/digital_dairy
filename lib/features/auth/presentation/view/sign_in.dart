import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/widget/custom_circular_indicator.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/custom_text_feild.dart';
import 'package:digital_dairy/core/widget/elevated_button.dart';
import 'package:digital_dairy/features/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A StatefulWidget for handling the sign-in process.
class SignInPage extends StatefulWidget {
  /// Initializes [key] for [SignInPage] widget.
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await context.read<AuthCubit>().signInUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.strings.authEnterPassword;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final TextTheme textTheme = context.textTheme;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthFailureState) {
          showAppSnackbar(
            context,
            message: state.msg,
            type: SnackbarType.error,
          );
        }
        if (state is AuthSuccessState) {
          showAppSnackbar(context, message: context.strings.authWelcomeBack);
          context.go(AppRoutes.home);
        }
      },
      builder: (BuildContext context, AuthState state) => Scaffold(
        body: Stack(
          children: <Widget>[
            // Main content
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
                          context.strings.authSignInToAccount,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withAlpha(140),
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
                        ),

                        const SizedBox(height: 15),
                        // Password feild
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

                        const SizedBox(height: 15),
                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => context.push(AppRoutes.forgotPassword),
                            child: Text(
                              context.strings.authForgotPassword,
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          child: CustomElevatedButton(
                            onPressed: _handleSignIn,
                            text: context.strings.authSignIn,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                context.strings.authDontHaveAccount,
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(150),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push(AppRoutes.signUp),
                                child: Text(
                                  context.strings.authSignUp,
                                  style: context.textTheme.bodyLarge?.copyWith(
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

            if (state is AuthLoading) const CustomLoadingIndicator.overlay(),
          ],
        ),
      ),
    );
  }
}
