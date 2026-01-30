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
    if (mounted) {
      unawaited(_scaleController.forward());
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      unawaited(_fadeController.forward());
    }

    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      unawaited(_slideController.forward());
    }

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
    final TextTheme textTheme = context.textTheme;
    const Color contrastColor = Colors.white;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppTheme.primaryGradient,
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
                                  contrastColor,
                                  contrastColor.withAlpha(240),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withAlpha(40),
                                  blurRadius: 25,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.menu_book_rounded,
                                size: 70,
                                color: AppTheme.primary,
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
                          Text(
                            context.strings.appName,
                            style: textTheme.displayLarge?.copyWith(
                              color: contrastColor,
                              letterSpacing: 2,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                              shadows: <Shadow>[
                                Shadow(
                                  color: Colors.black.withAlpha(50),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: contrastColor.withAlpha(40),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: contrastColor.withAlpha(30),
                              ),
                            ),
                            child: Text(
                              context.strings.splashTagline,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.copyWith(
                                color: contrastColor,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            runSpacing: 12,
                            children: <Widget>[
                              ...context.strings.splashSubtitle
                                  .split('.')
                                  .map((String text) => text.trim())
                                  .where((String text) => text.isNotEmpty)
                                  .map(
                                    (String text) => _buildFeatureChip(
                                      text,
                                      contrastColor,
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
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: contrastColor.withAlpha(30),
                      ),
                      child: const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            contrastColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      context.strings.loading,
                      style: textTheme.bodyMedium?.copyWith(
                        color: contrastColor.withAlpha(200),
                        letterSpacing: 0.5,
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
                child: Text(
                  'v1.0.0 • Made with ❤️',
                  style: textTheme.labelMedium?.copyWith(
                    color: contrastColor.withAlpha(150),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String text, Color color, TextTheme textTheme) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(50), width: 0.5),
        ),
        child: Text(
          text,
          style: textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      );
}
