import 'dart:io';

import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/features/cattle/presentation/widget/custom_container.dart';
import 'package:digital_dairy/features/sales/cubit/sales_cubit.dart';
import 'package:digital_dairy/features/sales/model/milk_sales_model.dart';
import 'package:digital_dairy/services/sales_pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

///
class BuyerSalesScreen extends StatefulWidget {
  ///
  const BuyerSalesScreen({
    required this.buyerId,
    required this.buyerName,
    super.key,
  });

  ///
  final String buyerId;

  ///
  final String buyerName;

  @override
  State<BuyerSalesScreen> createState() => _BuyerSalesScreenState();
}

class _BuyerSalesScreenState extends State<BuyerSalesScreen> {
  DateTime _selectedMonth = DateTime.now();
  final SalesPdfService _pdfService = SalesPdfService();
  List<MilkSale> _displayedSales = <MilkSale>[];

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  void _loadSales() {
    final DateTime startDate = DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    final DateTime endDate = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    );

    context.read<SalesCubit>().getSales(
      buyerId: widget.buyerId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  void _changeMonth(DateTime month) {
    setState(() => _selectedMonth = month);
    _loadSales();
  }

  Future<void> _handlePdfAction(String action, List<MilkSale> sales) async {
    if (sales.isEmpty) {
      showAppSnackbar(
        context,
        message: context.strings.noDataAvailable,
        type: SnackbarType.error,
      );
      return;
    }

    try {
      switch (action) {
        case 'preview':
          await _pdfService.previewPdf(
            sales: sales,
            buyerName: widget.buyerName,
            buyerId: widget.buyerId,
            selectedMonth: _selectedMonth,
          );
        case 'download':
          final File? file = await _pdfService.generateAndSaveSalesPdf(
            sales: sales,
            buyerName: widget.buyerName,
            buyerId: widget.buyerId,
            selectedMonth: _selectedMonth,
          );
          if (file != null && mounted) {
            showAppSnackbar(
              context,
              message: '${context.strings.pdfSavedTo} ${file.path}',
              type: SnackbarType.success,
            );
          } else if (mounted) {
            showAppSnackbar(
              context,
              message:
                  '${context.strings.error} ${context.strings.failToUploadImage}',
              type: SnackbarType.error,
            );
          }
        case 'share':
          await _pdfService.sharePdf(
            sales: sales,
            buyerName: widget.buyerName,
            buyerId: widget.buyerId,
            selectedMonth: _selectedMonth,
          );
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context,
          message: '${context.strings.error} $e',
          type: SnackbarType.error,
        );
      }
    } finally {}
  }

  double _calculateTotalQuantity(List<MilkSale> sales) =>
      sales.fold(0, (double sum, MilkSale sale) => sum + sale.quantityLitres);

  double _calculateTotalAmount(List<MilkSale> sales) => sales.fold(
    0,
    (double sum, MilkSale sale) => sum + (sale.totalAmount ?? 0.0),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScaffoldContainer(
      child: BlocConsumer<SalesCubit, SalesState>(
        listener: (BuildContext context, SalesState state) {
          if (state is GetSalesFailureState) {
            showAppSnackbar(
              context,
              message: state.errorMsg,
              type: SnackbarType.error,
            );
          }
        },
        builder: (BuildContext context, SalesState state) {
          final bool isLoading = state is SalesLoading;

          // Update displayed sales when state changes
          if (state is GetSalesSuccessState) {
            _displayedSales = state.sales;
          }

          return CustomScrollView(
            slivers: <Widget>[
              _buildAppBar(context, _displayedSales),

              SliverToBoxAdapter(child: _buildMonthSelector()),

              if (isLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (_displayedSales.isEmpty)
                SliverToBoxAdapter(child: _buildEmpty())
              else ...<Widget>[
                SliverToBoxAdapter(child: _buildSummaryCards(_displayedSales)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Text(
                      context.strings.transactionHistory,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                _buildSalesList(_displayedSales),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () async {
        final result = await context.push(
          AppRoutes.addSales,
          extra: <String, String?>{
            'id': widget.buyerId,
            'name': widget.buyerName,
          },
        );

        // Reload sales after adding new sale
        if (result == true || result == null) {
          _loadSales();
        }
      },
      elevation: 4,
      icon: const Icon(Icons.add_rounded),
      label: Text(context.strings.buyerAddSaleButton),
    ),
  );

  SliverAppBar _buildAppBar(BuildContext context, List<MilkSale> sales) =>
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
          widget.buyerName,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          if (sales.isNotEmpty)
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
              onSelected: (String value) => _handlePdfAction(value, sales),
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
                    '${_selectedMonth.year}',
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

  Widget _buildSummaryCards(List<MilkSale> sales) {
    final double totalQuantity = _calculateTotalQuantity(sales);
    final double totalAmount = _calculateTotalAmount(sales);
    final double avgPrice = totalQuantity > 0 ? totalAmount / totalQuantity : 0;
    final int transactionCount = sales.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          // Total Amount Card (Primary)
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
                        Icons.currency_rupee_rounded,
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
                            context.strings.totalRevenue,
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${totalAmount.toStringAsFixed(2)}',
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
                  icon: Icons.water_drop_rounded,
                  label: context.strings.salesTotalQuantity,
                  value: '${totalQuantity.toStringAsFixed(1)} L',
                  color: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.receipt_long_rounded,
                  label: context.strings.transactions,
                  value: '$transactionCount',
                  color: context.colorScheme.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Average price card
          CustomContainer(
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.trending_up_rounded,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        context.strings.avgPricePerLitre,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${avgPrice.toStringAsFixed(2)}',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

  SliverList _buildSalesList(List<MilkSale> sales) => SliverList(
    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      final MilkSale sale = sales[index];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: CustomContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
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
                          DateFormat('dd').format(sale.date),
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.primary,
                          ),
                        ),
                        Text(
                          _getLocalizedShortMonth(sale.date, context),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Sale details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.water_drop_rounded,
                              size: 16,
                              color: Color(0xFF3B82F6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${sale.quantityLitres.toStringAsFixed(1)} L',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '@ ₹${sale.pricePerLitre.toStringAsFixed(2)}/L',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        if (sale.notes != null &&
                            sale.notes!.isNotEmpty) ...<Widget>[
                          const SizedBox(height: 4),
                          Text(
                            sale.notes!,
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

                  // Amount
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '₹${(sale.totalAmount ?? 0.0).toStringAsFixed(2)}',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }, childCount: sales.length),
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
            Icons.receipt_long_outlined,
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
