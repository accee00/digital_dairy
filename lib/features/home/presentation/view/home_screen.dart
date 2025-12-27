import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///
class HomeScreen extends StatelessWidget {
  ///
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: <Widget>[
      SliverSafeArea(
        minimum: const EdgeInsets.all(20),
        sliver: SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildMilkSummaryCard(context),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              // _buildCattleHealthAlerts(context),
              // const SizedBox(height: 16),
              // _buildReminders(context),
              // const SizedBox(height: 16),
              // _buildRecentActivity(context),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _buildHeader(BuildContext context) => Container(
    padding: const EdgeInsets.all(15),
    decoration: AppTheme.glassmorphism(
      opacity: 0.15,
      blur: 90,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: NetworkImage(
                'https://img.freepik.com/free-vector/smiling-young-man-illustration_1308-174669.jpg',
              ),
              fit: BoxFit.cover,
            ),
            color: AppTheme.textOnPrimary.withAlpha(51),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.textOnPrimary.withAlpha(76)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Welcome, Harsh',
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.textOnPrimary.withAlpha(51),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.textOnPrimary.withAlpha(76)),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: AppTheme.textOnPrimary,
            size: 20,
          ),
        ),
      ],
    ),
  );

  Widget _buildMilkSummaryCard(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colorScheme.surface,
            colorScheme.surface.withAlpha(240),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.primary.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: colorScheme.primary.withAlpha(40),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Today's Summary",
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Milk Production Overview',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(153),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildSummaryItem(
                  context,
                  Icons.wb_sunny_rounded,
                  'Morning',
                  '12 L',
                  AppTheme.info,
                  '06:00 AM',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  Icons.nightlight_round,
                  'Evening',
                  '10 L',
                  AppTheme.secondary,
                  '06:00 PM',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildSummaryItem(
                  context,
                  Icons.analytics_rounded,
                  'Total',
                  '22 L',
                  AppTheme.primary,
                  'Daily Total',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  Icons.currency_rupee_rounded,
                  'Income',
                  '₹660',
                  AppTheme.success,
                  '@₹30/L',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
    String subtitle,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[color.withAlpha(25), color.withAlpha(15)],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withAlpha(100)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: color.withAlpha(20),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: color.withAlpha(51),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withAlpha(102)),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: context.textTheme.labelLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: context.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ],
    ),
  );

  Widget _buildQuickActions(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Quick Actions',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _actionButton(
                context,
                Icons.add_circle_outline,
                'Milk Entry',
                AppTheme.primary,
                () => context.push(AppRoutes.addMilk),
              ),
              _actionButton(
                context,
                Icons.pets_outlined,
                'New Cattle',
                AppTheme.secondary,
                () => context.push(AppRoutes.addCattle),
              ),
              _actionButton(
                context,
                Icons.account_balance_wallet_outlined,
                'Finance',
                AppTheme.success,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(76)),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: color.withAlpha(76),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: AppTheme.textOnPrimary, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildCattleHealthAlerts(BuildContext context) {
  //   final theme = Theme.of(context);

  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: AppTheme.warning.withAlpha(25),
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(color: AppTheme.warning.withAlpha(76), width: 1),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppTheme.warning.withAlpha(51),
  //           blurRadius: 12,
  //           offset: const Offset(0, 6),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: AppTheme.warning,
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: const Icon(
  //                 Icons.health_and_safety_outlined,
  //                 color: AppTheme.textOnPrimary,
  //                 size: 24,
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Text(
  //               'Cattle Health Alerts',
  //               style: theme.textTheme.titleMedium?.copyWith(
  //                 color: AppTheme.warning,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         _buildAlertItem(
  //           context,
  //           '⚠️',
  //           'Cow #12 missed milking today',
  //           AppTheme.error,
  //         ),
  //         const SizedBox(height: 8),
  //         _buildAlertItem(
  //           context,
  //           '💉',
  //           'Vaccination due for Cow #7',
  //           AppTheme.warning,
  //         ),
  //         const SizedBox(height: 8),
  //         _buildAlertItem(
  //           context,
  //           '🩺',
  //           'Pregnancy check reminder',
  //           AppTheme.info,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildReminders(BuildContext context) {
  //   final theme = Theme.of(context);

  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: AppTheme.info.withAlpha(25),
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(color: AppTheme.info.withAlpha(76), width: 1),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppTheme.info.withAlpha(51),
  //           blurRadius: 12,
  //           offset: const Offset(0, 6),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: AppTheme.info,
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: const Icon(
  //                 Icons.notifications_active_outlined,
  //                 color: AppTheme.textOnPrimary,
  //                 size: 24,
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Text(
  //               'Reminders',
  //               style: theme.textTheme.titleMedium?.copyWith(
  //                 color: AppTheme.info,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         _buildAlertItem(context, '🕗', 'Feed time for Cow #3', AppTheme.info),
  //         const SizedBox(height: 8),
  //         _buildAlertItem(
  //           context,
  //           '💊',
  //           'Medicine for Cow #5 at 4 PM',
  //           AppTheme.secondary,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildAlertItem(
  //   BuildContext context,
  //   String emoji,
  //   String text,
  //   Color color,
  // ) {
  //   final theme = Theme.of(context);

  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: color.withAlpha(51),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Row(
  //       children: [
  //         Text(emoji, style: const TextStyle(fontSize: 16)),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Text(
  //             text,
  //             style: theme.textTheme.bodyMedium?.copyWith(
  //               color: color,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildRecentActivity(BuildContext context) {
  //   final theme = Theme.of(context);
  //   final colorScheme = theme.colorScheme;

  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: colorScheme.surface,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: AppTheme.cardShadow,
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: <Widget>[
  //             Text(
  //               'Recent Activity',
  //               style: theme.textTheme.titleLarge?.copyWith(
  //                 color: colorScheme.primary,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //             TextButton(
  //               key: UniqueKey(),
  //               onPressed: () {},
  //               child: Text(
  //                 'View All',
  //                 style: theme.textTheme.bodySmall?.copyWith(
  //                   color: colorScheme.primary,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         _buildActivityItem(
  //           context,
  //           Icons.mail_lock,
  //           'Morning milk collection completed',
  //           '2 hours ago',
  //           AppTheme.success,
  //         ),
  //         const SizedBox(height: 12),
  //         _buildActivityItem(
  //           context,
  //           Icons.pets_outlined,
  //           'New cattle added to inventory',
  //           '5 hours ago',
  //           AppTheme.info,
  //         ),
  //         const SizedBox(height: 12),
  //         _buildActivityItem(
  //           context,
  //           Icons.medical_services_outlined,
  //           'Health checkup scheduled',
  //           '1 day ago',
  //           AppTheme.warning,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildActivityItem(
  //   BuildContext context,
  //   IconData icon,
  //   String title,
  //   String time,
  //   Color color,
  // ) {
  //   final theme = Theme.of(context);

  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: color.withAlpha(25),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: color.withAlpha(51), width: 1),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             color: color,
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Icon(icon, color: AppTheme.textOnPrimary, size: 20),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 title,
  //                 style: theme.textTheme.bodyMedium?.copyWith(
  //                   color: color,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               const SizedBox(height: 2),
  //               Text(
  //                 time,
  //                 style: theme.textTheme.bodySmall?.copyWith(
  //                   color: color.withAlpha(153),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
