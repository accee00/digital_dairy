import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/theme/app_theme.dart';
import 'package:digital_dairy/features/home/cubit/analytics_cubit.dart';
import 'package:digital_dairy/features/home/model/analytics_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

///
class HomeScreen extends StatefulWidget {
  ///
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch analytics when screen loads
    context.read<AnalyticsCubit>().fetchAnalytics();
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () => context.read<AnalyticsCubit>().refreshAnalytics(),
    child: CustomScrollView(
      slivers: <Widget>[
        SliverSafeArea(
          minimum: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                _buildHeader(context),
                const SizedBox(height: 24),
                BlocBuilder<AnalyticsCubit, AnalyticsState>(
                  builder: (BuildContext context, AnalyticsState state) {
                    if (state is AnalyticsLoading) {
                      return Column(
                        children: <Widget>[
                          _buildLoadingCard(context),
                          const SizedBox(height: 24),
                          _buildLoadingCard(context),
                        ],
                      );
                    } else if (state is AnalyticsError) {
                      return _buildErrorCard(context, state.message);
                    } else if (state is AnalyticsLoaded) {
                      return Column(
                        children: <Widget>[
                          _buildMilkSummaryCard(context, state.analytics),
                          const SizedBox(height: 24),
                          _buildMonthlyCard(context, state.analytics),
                        ],
                      );
                    }
                    return _buildEmptyCard(context);
                  },
                ),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    ),
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
        GestureDetector(
          onTap: () => context.push(AppRoutes.profile),
          child: Container(
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

  Widget _buildLoadingCard(BuildContext context) {
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
        ],
        border: Border.all(
          color: colorScheme.primary.withAlpha(40),
          width: 1.5,
        ),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
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
            color: colorScheme.error.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: colorScheme.error.withAlpha(40), width: 1.5),
      ),
      child: Column(
        children: <Widget>[
          Icon(Icons.error_outline, color: colorScheme.error, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            style: context.textTheme.bodyLarge?.copyWith(
              color: colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.read<AnalyticsCubit>().fetchAnalytics(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
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
        border: Border.all(
          color: colorScheme.primary.withAlpha(40),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          'No data available',
          style: context.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withAlpha(153),
          ),
        ),
      ),
    );
  }

  Widget _buildMilkSummaryCard(BuildContext context, AnalyticsModel analytics) {
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
                  '${analytics.todayMorningMilk.toStringAsFixed(1)} L',
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
                  '${analytics.todayEveningMilk.toStringAsFixed(1)} L',
                  context.isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.secondary,
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
                  '${analytics.todayTotalMilk.toStringAsFixed(1)} L',
                  context.isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.secondary,
                  'Daily Total',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  Icons.currency_rupee_rounded,
                  'Income',
                  '₹${analytics.todayIncome.toStringAsFixed(0)}',
                  AppTheme.success,
                  'Today',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyCard(BuildContext context, AnalyticsModel analytics) {
    final ColorScheme colorScheme = context.colorScheme;
    final DateTime now = DateTime.now();
    final String monthName = _getMonthName(now.month);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.secondary.withAlpha(30),
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
          color: AppTheme.secondary.withAlpha(100),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withAlpha(51),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.secondary.withAlpha(102)),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppTheme.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Monthly Summary',
                      style: context.textTheme.titleLarge?.copyWith(
                        color: AppTheme.secondary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      monthName,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondary.withAlpha(179),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildMonthlyItem(
                  context,
                  Icons.water_drop_rounded,
                  'Total Production',
                  '${analytics.monthTotalMilk.toStringAsFixed(1)} L',
                  AppTheme.info,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMonthlyItem(
                  context,
                  Icons.account_balance_wallet_rounded,
                  'Total Income',
                  '₹${analytics.monthIncome.toStringAsFixed(0)}',
                  AppTheme.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface.withAlpha(128),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.secondary.withAlpha(76)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildMonthStat(
                  context,
                  'Avg/Day',
                  '${(analytics.monthTotalMilk / now.day).toStringAsFixed(1)} L',
                  AppTheme.primary,
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: AppTheme.secondary.withAlpha(76),
                ),
                _buildMonthStat(
                  context,
                  'Days',
                  '${now.day}',
                  AppTheme.secondary,
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: AppTheme.secondary.withAlpha(76),
                ),
                _buildMonthStat(
                  context,
                  'Rate/L',
                  analytics.monthTotalMilk > 0
                      ? '₹${(analytics.monthIncome / analytics.monthTotalMilk).toStringAsFixed(0)}'
                      : '₹0',
                  AppTheme.success,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withAlpha(25),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withAlpha(76)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 12),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: color.withAlpha(179),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
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

  Widget _buildMonthStat(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) => Column(
    children: <Widget>[
      Text(
        label,
        style: context.textTheme.bodySmall?.copyWith(
          color: color.withAlpha(179),
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: context.textTheme.titleMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );

  String _getMonthName(int month) {
    const List<String> months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
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
}
