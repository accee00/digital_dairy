import 'dart:async';

import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/theme/app_theme.dart';
import 'package:digital_dairy/features/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

///
class SplashScreen extends StatefulWidget {
  ///
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
  }

  Future<void> _startAnimations() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    unawaited(_scaleController.forward());

    await Future<void>.delayed(const Duration(milliseconds: 500));
    unawaited(_fadeController.forward());

    await Future<void>.delayed(const Duration(milliseconds: 800));
    unawaited(_slideController.forward());

    // Check session after animations complete
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      unawaited(context.read<AuthCubit>().checkPersistedSession());
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthCubit, AuthState>(
    listener: (BuildContext context, AuthState state) {
      if (state is AuthSuccessState) {
        context.go(AppRoutes.home);
      } else if (state is SessionNotFoundState || state is AuthFailureState) {
        context.go(AppRoutes.signUp);
      }
    },
    child: Scaffold(body: _buildAnimatedContent(context)),
  );

  Widget _buildAnimatedContent(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final TextTheme textTheme = context.textTheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppTheme.primaryGradient,
          stops: <double>[0, 0.3, 0.7, 1],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (BuildContext context, Widget? child) =>
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  colorScheme.onPrimary,
                                  colorScheme.surface,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withAlpha(15),
                                  blurRadius: 25,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 12),
                                ),
                                BoxShadow(
                                  color: colorScheme.onPrimary.withAlpha(15),
                                  blurRadius: 10,
                                  spreadRadius: -5,
                                  offset: const Offset(0, -5),
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(
                                  color: colorScheme.onPrimary.withAlpha(15),
                                ),
                              ),
                              child: Icon(
                                Icons.menu_book_rounded,
                                size: 70,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                  ),
                  const SizedBox(height: 40),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: <Widget>[
                          ShaderMask(
                            shaderCallback: (Rect bounds) => LinearGradient(
                              colors: <Color>[
                                colorScheme.onPrimary,
                                colorScheme.surface,
                              ],
                            ).createShader(bounds),
                            child: Text(
                              context.strings.appName,
                              style: textTheme.displayLarge?.copyWith(
                                color: colorScheme.onPrimary,
                                letterSpacing: 2,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.onPrimary.withAlpha(30),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: colorScheme.onPrimary.withAlpha(15),
                              ),
                            ),
                            child: Text(
                              context.strings.splashTagline,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onPrimary,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            spacing: 15,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ...context.strings.splashSubtitle
                                  .split('.')
                                  .map((String text) => text.trim())
                                  .where((String text) => text.isNotEmpty)
                                  .map(
                                    (String text) => _buildFeatureChip(
                                      text,
                                      colorScheme.onPrimary,
                                      colorScheme,
                                      textTheme,
                                    ),
                                  ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withAlpha(100),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary.withAlpha(30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        context.strings.loading,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withAlpha(30),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: colorScheme.onPrimary.withAlpha(30),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    'v1.0.0 • Made with ❤️',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(
    String text,
    Color textColor,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: colorScheme.onPrimary.withAlpha(26),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: colorScheme.onPrimary.withAlpha(51),
        width: 0.5,
      ),
    ),
    child: Text(
      text,
      style: textTheme.labelSmall?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
    ),
  );
}
