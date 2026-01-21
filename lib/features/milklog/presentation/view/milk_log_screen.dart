// ignore_for_file: prefer_int_literals

import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/utils/enums.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/header_for_add.dart';
import 'package:digital_dairy/features/milklog/cubit/milk_cubit.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
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
  String _searchQuery = '';
  String _sortBy = 'Date';

  final List<String> _sortOptions = <String>[
    'Date',
    'Quantity',
    'Cattle Name',
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
      final MilkCubit milkCubit = context.read<MilkCubit>();
      final MilkState currentState = milkCubit.state;

      if (currentState is MilkSuccess && currentState.hasMore) {
        milkCubit.getMilkLog();
      }
    }
  }

  List<MilkModel> get _filteredMilkEntries {
    final List<MilkModel> milkEntries = context
        .read<MilkCubit>()
        .state
        .milkLogList;

    final List<MilkModel> filtered = milkEntries.where((MilkModel entry) {
      final bool matchesSearch =
          entry.cattleId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          entry.notes.toLowerCase().contains(_searchQuery.toLowerCase());

      if (_sortBy == 'Morning Shift') {
        return matchesSearch && entry.shift == ShiftType.morning;
      }
      if (_sortBy == 'Evening Shift') {
        return matchesSearch && entry.shift == ShiftType.evening;
      }
      return matchesSearch;
    }).toList();

    switch (_sortBy) {
      case 'Quantity':
        filtered.sort(
          (MilkModel a, MilkModel b) =>
              b.quantityInLiter.compareTo(a.quantityInLiter),
        );

      case 'Cattle Name':
        filtered.sort(
          (MilkModel a, MilkModel b) => a.cattleId.compareTo(b.cattleId),
        );

      default:
        filtered.sort((MilkModel a, MilkModel b) => b.date.compareTo(a.date));
    }

    return filtered;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<MilkCubit, MilkState>(
    buildWhen: (MilkState previous, MilkState current) =>
        previous.runtimeType != current.runtimeType,
    builder: (BuildContext context, MilkState state) {
      if (state is MilkLoading && state.milkLogList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is MilkFailure && state.milkLogList.isEmpty) {
        return Center(child: Text(state.message));
      }

      return Scaffold(
        body: CustomScaffoldContainer(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                toolbarHeight: 80,
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
                  child: _buildSearchAndFilters(context),
                ),
              ),
              _buildMilkEntriesList(context),
            ],
          ),
        ),
      );
    },
  );

  Widget _buildSearchAndFilters(BuildContext context) => Column(
    children: <Widget>[
      TextField(
        onChanged: (String value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: context.strings.milkScreenSearchHint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: context.colorScheme.outline),
          ),
          filled: true,
          fillColor: context.colorScheme.surface.withAlpha(200),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
      const SizedBox(height: 12),
      GestureDetector(
        onTap: () => _showSortOptions(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(100),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                context.strings.milkScreenSortFilterOptions,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    _getSortDisplayText(context),
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.sort,
                    size: 20,
                    color: context.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _buildMilkEntriesList(BuildContext context) {
    if (_filteredMilkEntries.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.water_drop_outlined,
                size: 64,
                color: context.colorScheme.onSurface.withAlpha(100),
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
                  color: context.colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final List<MilkModel> entries = _filteredMilkEntries;
    return SliverPadding(
      padding: EdgeInsets.only(
        top: 8,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).size.height * 0.2,
      ),
      sliver: SliverList.builder(
        itemCount: entries.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _buildSummaryRow(context);
          }
          if (index == entries.length) {
            final MilkState currentState = context.read<MilkCubit>().state;
            if (currentState is MilkSuccess && currentState.hasMore) {
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
            } else {
              return const SizedBox.shrink();
            }
          }
          return _buildMilkEntryCard(context, entries[index - 1]);
        },
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context) {
    final double totalMilk = _filteredMilkEntries.fold(
      0.0,
      (double sum, MilkModel e) => sum + e.quantityInLiter,
    );
    final double morningMilk = _filteredMilkEntries
        .where((MilkModel e) => e.shift == ShiftType.morning)
        .fold(0.0, (double sum, MilkModel e) => sum + e.quantityInLiter);
    final double eveningMilk = _filteredMilkEntries
        .where((MilkModel e) => e.shift == ShiftType.evening)
        .fold(0.0, (double sum, MilkModel e) => sum + e.quantityInLiter);

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

  Widget _buildMilkEntryCard(
    BuildContext context,
    MilkModel milkEntry,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _showMilkEntryDetail(context, milkEntry),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                milkEntry.cattle!.name,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getShiftColor(
                    milkEntry.shift.value,
                    context,
                  ).withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      milkEntry.shift == ShiftType.morning
                          ? Icons.wb_sunny
                          : Icons.nights_stay,
                      size: 14,
                      color: _getShiftColor(
                        milkEntry.shift.displayVal,
                        context,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      milkEntry.shift.displayVal,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: _getShiftColor(milkEntry.shift.value, context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Icon(
                Icons.water_drop,
                size: 16,
                color: context.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '${milkEntry.quantityInLiter.toStringAsFixed(1)}L',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.calendar_today,
                size: 16,
                color: context.colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDate(milkEntry.date, context),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ],
          ),
          if (milkEntry.notes.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              milkEntry.notes,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withAlpha(120),
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ),
  );

  String _getSortDisplayText(BuildContext context) {
    switch (_sortBy) {
      case 'Morning Shift':
        return '${context.strings.morning} Only';
      case 'Evening Shift':
        return '${context.strings.evening} Only';
      case 'All Shifts':
        return 'All Entries';
      default:
        return _sortBy;
    }
  }

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
      case 'Cattle Name':
        return Icons.pets;
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

  Color _getShiftColor(String shift, BuildContext context) {
    switch (shift) {
      case 'Morning':
        return Colors.orange;
      case 'Evening':
        return Colors.indigo;
      default:
        return context.colorScheme.primary;
    }
  }

  String _formatDate(DateTime date, BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateTime entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate.isAtSameMomentAs(today)) {
      return context.strings.milkScreenToday;
    }
    if (entryDate.isAtSameMomentAs(yesterday)) {
      return context.strings.milkScreenYesterday;
    }

    final String month = switch (date.month) {
      1 => context.strings.jan,
      2 => context.strings.feb,
      3 => context.strings.mar,
      4 => context.strings.apr,
      5 => context.strings.may,
      6 => context.strings.jun,
      7 => context.strings.jul,
      8 => context.strings.aug,
      9 => context.strings.sep,
      10 => context.strings.oct,
      11 => context.strings.nov,
      12 => context.strings.dec,
      _ => '',
    };
    return '${date.day} $month';
  }

  void _showMilkEntryDetail(BuildContext context, MilkModel milkEntry) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: context.colorScheme.surface,
        title: Row(
          children: <Widget>[
            const Icon(Icons.local_drink_rounded),
            const SizedBox(width: 8),
            Text(
              context.strings.milkScreenEntryDetail,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDetailRow(
              '🐄 ${context.strings.milkScreenEntryCattle}',
              milkEntry.cattle?.name ?? '-',
              context,
            ),
            _buildDetailRow(
              '📅 ${context.strings.milkScreenEntryDate}',
              _formatFullDate(milkEntry.date, context),
              context,
            ),
            _buildDetailRow(
              '⏰ ${context.strings.milkScreenEntryShift}',
              milkEntry.shift.displayVal,
              context,
            ),
            _buildDetailRow(
              '🥛 ${context.strings.milkScreenEntryQuantity}',
              '${milkEntry.quantityInLiter.toStringAsFixed(2)} L',
              context,
            ),
            if (milkEntry.notes.isNotEmpty) ...<Widget>[
              const Divider(height: 20),
              _buildDetailRow(
                '📝 ${context.strings.milkScreenEntryNotes}',
                milkEntry.notes,
                context,
              ),
            ],
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          FilledButton.icon(
            onPressed: () => context.pop(),
            label: Text(context.strings.milkScreenClose),
            icon: const Icon(Icons.close),
          ),
          FilledButton.icon(
            onPressed: () {
              context
                ..pop()
                ..pushNamed(AppRoutes.editMilk, extra: milkEntry);
            },
            icon: const Icon(Icons.edit),
            label: Text(context.strings.milkScreenEdit),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: context.textTheme.bodyMedium?.copyWith(fontSize: 15),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: context.textTheme.bodyMedium?.copyWith(fontSize: 15),
              ),
            ),
          ],
        ),
      );

  String _formatFullDate(DateTime date, BuildContext context) {
    final String month = switch (date.month) {
      1 => context.strings.jan,
      2 => context.strings.feb,
      3 => context.strings.mar,
      4 => context.strings.apr,
      5 => context.strings.may,
      6 => context.strings.jun,
      7 => context.strings.jul,
      8 => context.strings.aug,
      9 => context.strings.sep,
      10 => context.strings.oct,
      11 => context.strings.nov,
      12 => context.strings.dec,
      _ => '',
    };
    return '${date.day} $month ${date.year}';
  }
}
