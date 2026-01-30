import 'package:digital_dairy/features/home/cubit/analytics_cubit.dart';

import 'package:digital_dairy/features/home/presentation/widgets/home_header.dart';
import 'package:digital_dairy/features/home/presentation/widgets/milk_summary_card.dart';
import 'package:digital_dairy/features/home/presentation/widgets/monthly_summary_card.dart';
import 'package:digital_dairy/features/home/presentation/widgets/quick_actions_card.dart';
import 'package:digital_dairy/features/home/presentation/widgets/status_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                const HomeHeader(),
                const SizedBox(height: 24),
                BlocBuilder<AnalyticsCubit, AnalyticsState>(
                  builder: (BuildContext context, AnalyticsState state) {
                    if (state is AnalyticsLoading) {
                      return const Column(
                        children: <Widget>[
                          LoadingCard(),
                          SizedBox(height: 24),
                          LoadingCard(),
                        ],
                      );
                    } else if (state is AnalyticsError) {
                      return ErrorCard(message: state.message);
                    } else if (state is AnalyticsLoaded) {
                      return Column(
                        children: <Widget>[
                          MilkSummaryCard(analytics: state.analytics),
                          const SizedBox(height: 24),
                          const QuickActionsCard(),
                          const SizedBox(height: 24),
                          MonthlySummaryCard(analytics: state.analytics),
                        ],
                      );
                    }
                    return const EmptyCard();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
