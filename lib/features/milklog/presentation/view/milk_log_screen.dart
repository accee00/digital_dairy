import 'dart:async';

import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/utils/debouncer.dart';
import 'package:digital_dairy/core/utils/enums.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/header_for_add.dart';
import 'package:digital_dairy/features/milklog/cubit/milk_cubit.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:digital_dairy/features/milklog/presentation/widget/milk_entry_card.dart';
import 'package:digital_dairy/features/milklog/presentation/widget/search_and_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

///
class MilkScreen extends StatefulWidget {
  ///
  const MilkScreen({super.key});

  @override
  State<MilkScreen> createState() => _MilkScreenState();
}

class _MilkScreenState extends State<MilkScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  String _sortBy = 'Date';
  final Debouncer debouncer = Debouncer(const Duration(milliseconds: 500));
  final List<String> _sortOptions = <String>[
    'Date',
    'Quantity',
    'Morning Shift',
    'Evening Shift',
    'All Shifts',
  ];

  @override
  void initState() {
    super.initState();
    context.read<MilkCubit>().getMilkLog();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MilkCubit>().loadMore();
    }
  }

  void _performSearch() {
    final String? shift = _sortBy == 'Morning Shift'
        ? 'Morning'
        : _sortBy == 'Evening Shift'
        ? 'Evening'
        : null;

    context.read<MilkCubit>().applyFilters(
      query: _searchQuery.isNotEmpty ? _searchQuery : null,
      shift: shift,
      sortByQuantity: _sortBy == 'Quantity',
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScaffoldContainer(
      child: BlocListener<MilkCubit, MilkState>(
        listener: (BuildContext context, MilkState state) {
          if (state is MilkFailure && state.milkLogList.isEmpty) {
            showAppSnackbar(
              context,
              message: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {});
            return context.read<MilkCubit>().refreshMilkLog();
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                title: HeaderForAdd(
                  padding: EdgeInsets.zero,
                  title: context.strings.navbarMilKLog,
                  subTitle: '',
                  onTap: () {
                    context.push(AppRoutes.addMilk);
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SearchAndFilters(
                    searchController: _searchController,
                    searchQuery: _searchQuery,
                    onSearchChanged: (String value) {
                      setState(() => _searchQuery = value);
                      debouncer.run(_performSearch);
                    },
                    onSearchCleared: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                      _debounce?.cancel();
                      context.read<MilkCubit>().getMilkLog(refresh: true);
                    },

                    sortBy: _sortBy,
                    onSortTapped: () => _showSortOptions(context),
                  ),
                ),
              ),
              BlocBuilder<MilkCubit, MilkState>(
                builder: (BuildContext context, MilkState state) {
                  if (state is MilkLoading && state.milkLogList.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final List<MilkModel> sortedEntries = state.milkLogList;

                  if (sortedEntries.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.water_drop_outlined,
                              size: 64,
                              color: context.colorScheme.onSurface.withAlpha(
                                100,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.strings.milkScreenNoEntriesFound,
                              style: context.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              context.strings.milkScreenAdjustFilters,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.onSurface.withAlpha(
                                  150,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: EdgeInsets.only(
                      top: 8,
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).size.height * 0.2,
                    ),
                    sliver: SliverList.builder(
                      itemCount: sortedEntries.length + 2,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return _buildSummaryRow(context, sortedEntries);
                        }
                        if (index == sortedEntries.length + 1) {
                          if (state is MilkSuccess && state.hasMore) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    const CircularProgressIndicator(),
                                    const SizedBox(height: 8),
                                    Text(
                                      context.strings.milkScreenLoadingMore,
                                      style: context.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }
                        return MilkEntryCard(
                          milkEntry: sortedEntries[index - 1],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildSummaryRow(BuildContext context, List<MilkModel> entries) {
    final double totalMilk = entries.fold(
      0,
      (double sum, MilkModel e) => sum + e.quantityInLiter,
    );
    final double morningMilk = entries
        .where((MilkModel e) => e.shift == ShiftType.morning)
        .fold(0, (double sum, MilkModel e) => sum + e.quantityInLiter);
    final double eveningMilk = entries
        .where((MilkModel e) => e.shift == ShiftType.evening)
        .fold(0, (double sum, MilkModel e) => sum + e.quantityInLiter);

    return Container(
      margin: const EdgeInsets.only(bottom: 12, top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildSummaryItem(
            context,
            context.strings.milkScreenSummaryTotal,
            '${totalMilk.toStringAsFixed(1)}L',
            Icons.water_drop,
            context.colorScheme.primary,
          ),
          _buildSummaryItem(
            context,
            context.strings.milkScreenSummaryMorning,
            '${morningMilk.toStringAsFixed(1)}L',
            Icons.wb_sunny,
            Colors.orange,
          ),
          _buildSummaryItem(
            context,
            context.strings.milkScreenSummaryEvening,
            '${eveningMilk.toStringAsFixed(1)}L',
            Icons.nights_stay,
            Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Icon(icon, color: color, size: 20),
      const SizedBox(height: 4),
      Text(
        title,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colorScheme.onSurface.withAlpha(150),
        ),
      ),
      Text(
        value,
        style: context.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              context.strings.milkScreenSortFilterOptions,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._sortOptions.map(
              (String option) => ListTile(
                leading: Icon(
                  _getOptionIcon(option),
                  color: _sortBy == option
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurface.withAlpha(150),
                ),
                title: Text(option),
                trailing: _sortBy == option
                    ? Icon(Icons.check, color: context.colorScheme.primary)
                    : null,
                onTap: () {
                  setState(() => _sortBy = option);
                  Navigator.pop(context);
                  _performSearch();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getOptionIcon(String option) {
    switch (option) {
      case 'Date':
        return Icons.calendar_today;
      case 'Quantity':
        return Icons.water_drop;
      case 'Morning Shift':
        return Icons.wb_sunny;
      case 'Evening Shift':
        return Icons.nights_stay;
      case 'All Shifts':
        return Icons.all_inclusive;
      default:
        return Icons.sort;
    }
  }
}
