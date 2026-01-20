import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/features/auth/presentation/view/forgot_password.dart';
import 'package:digital_dairy/features/auth/presentation/view/sign_in.dart';
import 'package:digital_dairy/features/auth/presentation/view/sign_up.dart';
import 'package:digital_dairy/features/auth/presentation/view/splash_screen.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:digital_dairy/features/cattle/presentation/view/add_cattle_screen.dart';
import 'package:digital_dairy/features/cattle/presentation/view/cattle_detail_screen.dart';
import 'package:digital_dairy/features/cattle/presentation/view/cattle_milk_detail_screen.dart';
import 'package:digital_dairy/features/home/presentation/view/main_screen.dart';
import 'package:digital_dairy/features/home/presentation/view/notification_screen.dart';
import 'package:digital_dairy/features/home/presentation/view/profile_screen.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:digital_dairy/features/milklog/presentation/view/add_milk_screen.dart';
import 'package:digital_dairy/features/sales/model/buyer_model.dart';
import 'package:digital_dairy/features/sales/presentation/add_buyer_screen.dart';
import 'package:digital_dairy/features/sales/presentation/add_sales_screen.dart';
import 'package:digital_dairy/features/sales/presentation/buyer_sales_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        name: AppRoutes.splash,
        path: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),
      GoRoute(
        name: AppRoutes.signUp,
        path: AppRoutes.signUp,
        builder: (BuildContext context, GoRouterState state) =>
            const SignUpPage(),
      ),
      GoRoute(
        name: AppRoutes.signIn,
        path: AppRoutes.signIn,
        builder: (BuildContext context, GoRouterState state) =>
            const SignInPage(),
      ),
      GoRoute(
        name: AppRoutes.forgotPassword,
        path: AppRoutes.forgotPassword,
        builder: (BuildContext context, GoRouterState state) =>
            const ForgotPasswordPage(),
      ),
      GoRoute(
        name: AppRoutes.home,
        path: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) =>
            const MainScreen(),
      ),
      GoRoute(
        name: AppRoutes.addCattle,
        path: AppRoutes.addCattle,
        builder: (BuildContext context, GoRouterState state) {
          final Cattle? cattle = state.extra as Cattle?;
          return AddCattleScreen(cattle: cattle);
        },
      ),
      GoRoute(
        name: AppRoutes.cattleDetail,
        path: AppRoutes.cattleDetail,
        builder: (BuildContext context, GoRouterState state) {
          final Cattle cattle = state.extra! as Cattle;
          return CattleDetailScreen(cattle: cattle);
        },
      ),
      GoRoute(
        name: AppRoutes.addMilk,
        path: AppRoutes.addMilk,
        builder: (BuildContext context, GoRouterState state) =>
            const AddMilkScreen(),
      ),
      GoRoute(
        name: AppRoutes.editMilk,
        path: AppRoutes.editMilk,
        builder: (BuildContext context, GoRouterState state) {
          final MilkModel milkModel = state.extra! as MilkModel;
          return AddMilkScreen(milkModel: milkModel);
        },
      ),

      /// Add Buyer
      GoRoute(
        name: AppRoutes.addBuyer,
        path: AppRoutes.addBuyer,
        builder: (BuildContext context, GoRouterState state) {
          final Buyer? buyer = state.extra as Buyer?;
          return AddBuyerScreen(buyer: buyer);
        },
      ),

      /// Add Sales
      GoRoute(
        name: AppRoutes.addSales,
        path: AppRoutes.addSales,
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic>? buyerData =
              state.extra as Map<String, dynamic>?;
          return AddMilkSaleScreen(buyer: buyerData);
        },
      ),

      /// Add Buyer Sales
      GoRoute(
        path: AppRoutes.buyerSales,
        name: AppRoutes.buyerSales,
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic> extra =
              state.extra! as Map<String, dynamic>;
          final String buyerId = extra['buyerId'] as String;
          final String buyerName = extra['buyerName'] as String;

          return BuyerSalesScreen(buyerId: buyerId, buyerName: buyerName);
        },
      ),

      /// Cattle milk details
      GoRoute(
        name: AppRoutes.cattleMilkDetail,
        path: AppRoutes.cattleMilkDetail,
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic> extra =
              state.extra! as Map<String, dynamic>;
          return CattleMilkDetailScreen(
            cattleId: extra['cattleId'] as String,
            cattleName: extra['cattleName'] as String,
          );
        },
      ),

      /// Profile
      GoRoute(
        name: AppRoutes.profile,
        path: AppRoutes.profile,
        builder: (BuildContext context, GoRouterState state) =>
            const ProfileScreen(),
      ),

      /// Notification
      GoRoute(
        name: AppRoutes.notification,
        path: AppRoutes.notification,
        builder: (BuildContext context, GoRouterState state) =>
            const NotificationScreen(),
      ),
    ],
  );
}
