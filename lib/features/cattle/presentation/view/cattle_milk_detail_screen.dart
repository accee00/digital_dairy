import 'dart:io';

import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/utils/enums.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/cattle/presentation/widget/custom_container.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:digital_dairy/services/milk_pdf_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

///
class CattleMilkDetailScreen extends StatefulWidget {
  ///
  const CattleMilkDetailScreen({
    required this.cattleId,
    required this.cattleName,
    super.key,
  });

  ///
  final String cattleId;

  ///
  final String cattleName;

  @override
  State<CattleMilkDetailScreen> createState() => _CattleMilkDetailScreenState();
}

class _CattleMilkDetailScreenState extends State<CattleMilkDetailScreen> {
  DateTime _selectedMonth = DateTime.now();
  final MilkPdfService _pdfService = MilkPdfService();

  @override
  void initState() {
    super.initState();
    _loadMilkLogs();
  }

  void _loadMilkLogs() {
    final DateTime startDate = DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    final DateTime endDate = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    );

    context.read<CattleCubit>().getMilkLogByCattle(
      cattleId: widget.cattleId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  void _changeMonth(DateTime month) {
    setState(() => _selectedMonth = month);
    _loadMilkLogs();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScaffoldContainer(
      child: BlocBuilder<CattleCubit, CattleState>(
        builder: (BuildContext context, CattleState state) {
          final bool isLoading = state is CattleMilkLogLoading;
          final List<MilkModel> logs = state is CattleMilkLogLoaded
              ? state.milkLogs
              : <MilkModel>[];

          return CustomScrollView(
            slivers: <Widget>[
              _buildAppBar(context, logs),

              /// Month selector
              SliverToBoxAdapter(child: _buildMonthSelector()),

              /// Loading state
              if (isLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              /// Empty state
              else if (logs.isEmpty)
                SliverToBoxAdapter(child: _buildEmpty())
              /// Summary cards
              else ...<Widget>[
                SliverToBoxAdapter(child: _buildSummaryCards(logs)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Text(
                      context.strings.dailyRecords,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                _buildMilkList(logs),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
      ),
    ),
  );

  SliverAppBar _buildAppBar(BuildContext context, List<MilkModel> logs) =>
      SliverAppBar(
        pinned: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          height: 43,
          width: 43,
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: const EdgeInsets.only(left: 10),
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
        title: Text(
          widget.cattleName,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          if (logs.isNotEmpty)
            PopupMenuButton<String>(
              icon: Container(
                height: 43,
                width: 43,
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.more_vert_rounded,
                  color: context.colorScheme.onSurface,
                ),
              ),
              onSelected: (String value) => _handlePdfAction(value, logs),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'preview',
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.visibility_rounded, size: 20),
                      const SizedBox(width: 12),
                      Text(context.strings.previewPdf),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'download',
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.download_rounded, size: 20),
                      const SizedBox(width: 12),
                      Text(context.strings.downloadPdf),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'share',
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.share_rounded, size: 20),
                      const SizedBox(width: 12),
                      Text(context.strings.sharePdf),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(width: 8),
        ],
      );

  Future<void> _handlePdfAction(String action, List<MilkModel> logs) async {
    try {
      switch (action) {
        case 'preview':
          await _pdfService.previewPdf(
            logs: logs,
            cattleName: widget.cattleName,
            cattleId: widget.cattleId,
            selectedMonth: _selectedMonth,
          );
        case 'download':
          final File? file = await _pdfService.generateAndSaveMilkPdf(
            logs: logs,
            cattleName: widget.cattleName,
            cattleId: widget.cattleId,
            selectedMonth: _selectedMonth,
          );
          if (file != null && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.strings.pdfSavedTo.replaceAll('{path}', file.path),
                ),
                backgroundColor: Colors.green,
                action: SnackBarAction(
                  label: context.strings.ok,
                  onPressed: () {},
                  textColor: Colors.white,
                ),
              ),
            );
          }
        case 'share':
          await _pdfService.sharePdf(
            logs: logs,
            cattleName: widget.cattleName,
            cattleId: widget.cattleId,
            selectedMonth: _selectedMonth,
          );
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context,
          message: context.strings.error.replaceAll('{error}', e.toString()),
          type: SnackbarType.error,
        );
      }
    }
  }

  Widget _buildMonthSelector() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.chevron_left_rounded,
              color: context.colorScheme.onSurface,
              size: 35,
            ),
            onPressed: () => _changeMonth(
              DateTime(_selectedMonth.year, _selectedMonth.month - 1),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    _getLocalizedMonthName(_selectedMonth, context),
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy').format(_selectedMonth),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              size: 35,
              Icons.chevron_right_rounded,
              color: context.colorScheme.onSurface,
            ),
            onPressed: () {
              final DateTime nextMonth = DateTime(
                _selectedMonth.year,
                _selectedMonth.month + 1,
              );
              if (nextMonth.isBefore(DateTime.now()) ||
                  nextMonth.month == DateTime.now().month) {
                _changeMonth(nextMonth);
              }
            },
          ),
        ],
      ),
    ),
  );

  Widget _buildSummaryCards(List<MilkModel> logs) {
    final double totalMilk = logs.fold(
      0,
      (double sum, MilkModel m) => sum + m.quantityInLiter,
    );

    final double avgMilk = totalMilk / logs.length;

    // Calculate morning and evening totals
    final double morningMilk = logs
        .where((MilkModel m) => m.shift == ShiftType.morning)
        .fold(0, (double sum, MilkModel m) => sum + m.quantityInLiter);

    final double eveningMilk = logs
        .where((MilkModel m) => m.shift == ShiftType.evening)
        .fold(0, (double sum, MilkModel m) => sum + m.quantityInLiter);

    final int daysRecorded = logs
        .map((MilkModel m) => m.date.day)
        .toSet()
        .length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          // Total Milk Card (Primary)
          CustomContainer(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.water_drop_rounded,
                        color: context.colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            context.strings.totalProduction,
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${totalMilk.toStringAsFixed(1)} L',
                            style: context.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Secondary stats row
          Row(
            children: <Widget>[
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.trending_up_rounded,
                  label: context.strings.dailyAverage,
                  value: '${avgMilk.toStringAsFixed(1)} L',
                  color: context.colorScheme.tertiary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.calendar_month_rounded,
                  label: context.strings.daysRecorded,
                  value: '$daysRecorded',
                  color: context.colorScheme.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Morning/Evening breakdown
          Row(
            children: <Widget>[
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.wb_sunny_rounded,
                  label: context.strings.morning,
                  value: '${morningMilk.toStringAsFixed(1)} L',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.nightlight_round,
                  label: context.strings.evening,
                  value: '${eveningMilk.toStringAsFixed(1)} L',
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) => CustomContainer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 12),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  SliverList _buildMilkList(List<MilkModel> logs) => SliverList(
    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      final MilkModel milk = logs[index];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: CustomContainer(
          child: Row(
            children: <Widget>[
              // Date indicator
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: context.colorScheme.secondary.withAlpha(100),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      DateFormat('dd').format(milk.date),
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    Text(
                      _getLocalizedShortMonth(milk.date, context),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Shift info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          milk.shift == ShiftType.morning
                              ? Icons.wb_sunny_rounded
                              : Icons.nightlight_round,
                          size: 16,
                          color: milk.shift == ShiftType.morning
                              ? Colors.orange
                              : Colors.indigo,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          milk.shift == ShiftType.morning
                              ? context.strings.morning
                              : context.strings.evening,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (milk.notes.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        milk.notes,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Quantity
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${milk.quantityInLiter.toStringAsFixed(1)} L',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }, childCount: logs.length),
  );

  Widget _buildEmpty() => Padding(
    padding: const EdgeInsets.all(40),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.water_drop_outlined,
            size: 64,
            color: context.colorScheme.outline,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          context.strings.noMilkRecordsFound,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.strings.recordsWillAppear.replaceAll(
            'monthYear',
            '${_getLocalizedMonthName(_selectedMonth, context)} ${_selectedMonth.year}',
          ),
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  // Helper methods for localized dates
  String _getLocalizedMonthName(DateTime date, BuildContext context) {
    switch (date.month) {
      case 1:
        return context.strings.monthJanuary;
      case 2:
        return context.strings.monthFebruary;
      case 3:
        return context.strings.monthMarch;
      case 4:
        return context.strings.monthApril;
      case 5:
        return context.strings.monthMay;
      case 6:
        return context.strings.monthJune;
      case 7:
        return context.strings.monthJuly;
      case 8:
        return context.strings.monthAugust;
      case 9:
        return context.strings.monthSeptember;
      case 10:
        return context.strings.monthOctober;
      case 11:
        return context.strings.monthNovember;
      case 12:
        return context.strings.monthDecember;
      default:
        return '';
    }
  }

  String _getLocalizedShortMonth(DateTime date, BuildContext context) {
    switch (date.month) {
      case 1:
        return context.strings.jan;
      case 2:
        return context.strings.feb;
      case 3:
        return context.strings.mar;
      case 4:
        return context.strings.apr;
      case 5:
        return context.strings.may;
      case 6:
        return context.strings.jun;
      case 7:
        return context.strings.jul;
      case 8:
        return context.strings.aug;
      case 9:
        return context.strings.sep;
      case 10:
        return context.strings.oct;
      case 11:
        return context.strings.nov;
      case 12:
        return context.strings.dec;
      default:
        return '';
    }
  }
}
