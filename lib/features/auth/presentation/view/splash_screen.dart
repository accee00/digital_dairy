import 'dart:async';

import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/theme/app_theme.dart';
import 'package:digital_dairy/features/auth/presentation/view/sign_up.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

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

    // Initialize animation controllers
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

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _startAnimations();

    // Navigate to home screen after delay
    Future<void>.delayed(const Duration(milliseconds: 3500), _navigateToHome);
  }

  Future<void> _startAnimations() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    unawaited(_scaleController.forward());

    await Future<void>.delayed(const Duration(milliseconds: 500));
    unawaited(_fadeController.forward());

    await Future<void>.delayed(const Duration(milliseconds: 800));
    unawaited(_slideController.forward());
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => const SignUpPage()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Would navigate to home screen'),
        backgroundColor: context.colorScheme.primary,
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    final TextTheme textTheme = context.textTheme;

    return Scaffold(
      body: Container(
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
              // Logo and App Name Section
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
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                    ),

                    const SizedBox(height: 40),

                    // App Title with Fade Animation
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

              // Bottom Section with Loading Indicator
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

              // Version Info with Modern Design
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
      color: colorScheme.onPrimary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: colorScheme.onPrimary.withOpacity(0.2),
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
