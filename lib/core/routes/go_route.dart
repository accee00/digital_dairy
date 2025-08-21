import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/features/auth/presentation/view/forgot_password.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:digital_dairy/features/cattle/presentation/view/add_cattle_screen.dart';
import 'package:digital_dairy/features/cattle/presentation/view/cattle_detail_screen.dart';
import 'package:digital_dairy/features/home/presentation/view/main_screen.dart';
import 'package:digital_dairy/features/auth/presentation/view/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:digital_dairy/features/auth/presentation/view/splash_screen.dart';
import 'package:digital_dairy/features/auth/presentation/view/sign_up.dart';

///
class AppRouteConfig {
  ///
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  ///
  static BuildContext? get context => navigatorKey.currentContext;

  ///
  static GoRouter get router => _router;

  ///
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (BuildContext context, GoRouterState state) =>
            const SignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (BuildContext context, GoRouterState state) =>
            const SignInPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (BuildContext context, GoRouterState state) =>
            const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) =>
            const MainScreen(),
      ),
      GoRoute(
        path: AppRoutes.addCattle,
        builder: (BuildContext context, GoRouterState state) =>
            const AddCattleScreen(),
      ),
      GoRoute(
        path: AppRoutes.cattleDetail,
        builder: (BuildContext context, GoRouterState state) {
          final Cattle cattle = state.extra! as Cattle;
          return CattleDetailScreen(cattle: cattle);
        },
      ),
    ],
  );
}
