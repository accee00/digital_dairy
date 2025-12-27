import 'dart:io';

import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/widget/custom_container.dart';
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
  bool _isGeneratingPdf = false;

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

  void _onMonthChanged(DateTime newMonth) {
    setState(() {
      _selectedMonth = newMonth;
    });
    _loadSales();
  }

  Future<void> _showMonthPicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'Select Month',
    );

    if (pickedDate != null) {
      _onMonthChanged(DateTime(pickedDate.year, pickedDate.month));
    }
  }

  Future<void> _showPdfOptions(List<MilkSale> sales) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colorScheme.outline.withAlpha(128),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Export Options',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildPdfOptionTile(
                icon: Icons.picture_as_pdf_rounded,
                title: 'Download PDF',
                subtitle: 'Save to device storage',
                onTap: () async {
                  Navigator.pop(context);
                  await _downloadPdf(sales);
                },
              ),
              _buildPdfOptionTile(
                icon: Icons.preview_rounded,
                title: 'Preview PDF',
                subtitle: 'View before downloading',
                onTap: () async {
                  Navigator.pop(context);
                  await _previewPdf(sales);
                },
              ),
              _buildPdfOptionTile(
                icon: Icons.share_rounded,
                title: 'Share PDF',
                subtitle: 'Share via apps',
                onTap: () async {
                  Navigator.pop(context);
                  await _sharePdf(sales);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPdfOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) => ListTile(
    onTap: onTap,
    leading: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: context.colorScheme.primary, size: 24),
    ),
    title: Text(
      title,
      style: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    ),
    subtitle: Text(subtitle),
    trailing: Icon(
      Icons.chevron_right_rounded,
      color: context.colorScheme.outline,
    ),
  );

  Future<void> _downloadPdf(List<MilkSale> sales) async {
    if (sales.isEmpty) {
      showAppSnackbar(
        context,
        message: 'No sales data to export',
        type: SnackbarType.error,
      );
      return;
    }

    setState(() => _isGeneratingPdf = true);

    try {
      final File? file = await _pdfService.generateAndSaveSalesPdf(
        sales: sales,
        buyerName: widget.buyerName,
        buyerId: widget.buyerId,
        selectedMonth: _selectedMonth,
      );

      if (file != null) {
        if (!mounted) {
          return;
        }
        showAppSnackbar(
          context,
          message: 'PDF saved to: ${file.path}',
          type: SnackbarType.success,
        );
      } else {
        if (!mounted) {
          return;
        }
        showAppSnackbar(
          context,
          message: 'Failed to generate PDF',
          type: SnackbarType.error,
        );
      }
    } catch (e) {
      showAppSnackbar(context, message: 'Error: $e', type: SnackbarType.error);
    } finally {
      setState(() => _isGeneratingPdf = false);
    }
  }

  Future<void> _previewPdf(List<MilkSale> sales) async {
    if (sales.isEmpty) {
      showAppSnackbar(
        context,
        message: 'No sales data to preview',
        type: SnackbarType.error,
      );
      return;
    }

    setState(() => _isGeneratingPdf = true);

    try {
      await _pdfService.previewPdf(
        sales: sales,
        buyerName: widget.buyerName,
        buyerId: widget.buyerId,
        selectedMonth: _selectedMonth,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      showAppSnackbar(context, message: 'Error: $e', type: SnackbarType.error);
    } finally {
      setState(() => _isGeneratingPdf = false);
    }
  }

  Future<void> _sharePdf(List<MilkSale> sales) async {
    if (sales.isEmpty) {
      showAppSnackbar(
        context,
        message: 'No sales data to share',
        type: SnackbarType.error,
      );
      return;
    }

    setState(() => _isGeneratingPdf = true);

    try {
      await _pdfService.sharePdf(
        sales: sales,
        buyerName: widget.buyerName,
        buyerId: widget.buyerId,
        selectedMonth: _selectedMonth,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      showAppSnackbar(context, message: 'Error: $e', type: SnackbarType.error);
    } finally {
      setState(() => _isGeneratingPdf = false);
    }
  }

  double _calculateTotalQuantity(List<MilkSale> sales) =>
      sales.fold(0, (double sum, MilkSale sale) => sum + sale.quantityLitres);

  double _calculateTotalAmount(List<MilkSale> sales) => sales.fold(
    0,
    (double sum, MilkSale sale) => sum + (sale.totalAmount ?? 0.0),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBody: true,
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
          final List<MilkSale> sales = state is GetSalesSuccessState
              ? state.sales
              : <MilkSale>[];

          return CustomScrollView(
            slivers: <Widget>[
              _buildAppBar(context, sales),
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: _buildBuyerInfoCard(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildMonthSelector(),
                    ),
                    if (_isGeneratingPdf)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Generating PDF...',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (isLoading && !_isGeneratingPdf)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      )
                    else if (sales.isNotEmpty) ...<Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                        child: _buildSummaryCards(sales),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Transactions',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _showPdfOptions(sales),
                              icon: const Icon(
                                Icons.file_download_outlined,
                                size: 18,
                              ),
                              label: const Text('Export'),
                              style: TextButton.styleFrom(
                                foregroundColor: context.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              if (!isLoading && sales.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: context.colorScheme.surfaceContainerHighest
                                .withAlpha(77),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: context.colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No sales found',
                          style: context.textTheme.titleLarge?.copyWith(
                            color: context.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No transactions in ${DateFormat('MMMM yyyy').format(_selectedMonth)}',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (!isLoading && sales.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((
                      BuildContext context,
                      int index,
                    ) {
                      final MilkSale sale = sales[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildSaleCard(sale),
                      );
                    }, childCount: sales.length),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () {
        context.push(
          AppRoutes.addSales,
          extra: <String, String?>{
            'id': widget.buyerId,
            'name': widget.buyerName,
          },
        );
      },
      elevation: 4,
      icon: const Icon(Icons.add_rounded),
      label: const Text('Add Sale'),
    ),
  );

  Widget _buildMonthSelector() => CustomContainer(
    child: Row(
      children: <Widget>[
        _buildMonthNavButton(
          icon: Icons.chevron_left_rounded,
          onPressed: () {
            final DateTime previousMonth = DateTime(
              _selectedMonth.year,
              _selectedMonth.month - 1,
            );
            _onMonthChanged(previousMonth);
          },
        ),
        Expanded(
          child: InkWell(
            onTap: _showMonthPicker,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.calendar_today_rounded,
                    color: context.colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat('MMMM yyyy').format(_selectedMonth),
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: context.colorScheme.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildMonthNavButton(
          icon: Icons.chevron_right_rounded,
          onPressed: () {
            final DateTime nextMonth = DateTime(
              _selectedMonth.year,
              _selectedMonth.month + 1,
              1,
            );
            final DateTime now = DateTime.now();
            if (nextMonth.year < now.year ||
                (nextMonth.year == now.year && nextMonth.month <= now.month)) {
              _onMonthChanged(nextMonth);
            }
          },
        ),
      ],
    ),
  );

  Widget _buildMonthNavButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: context.colorScheme.primary, size: 24),
      ),
    ),
  );

  SliverAppBar _buildAppBar(BuildContext context, List<MilkSale> sales) =>
      SliverAppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        pinned: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.colorScheme.onSurface,
              size: 18,
            ),
          ),
        ),
        title: Text(
          'Sales History',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onSurface,
          ),
        ),
        actions: [
          if (sales.isNotEmpty)
            IconButton(
              onPressed: () => _showPdfOptions(sales),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.picture_as_pdf_rounded,
                  color: context.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      );

  // ... rest of the widget methods remain the same ...
  Widget _buildBuyerInfoCard() => CustomContainer(
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            context.colorScheme.primary,
            context.colorScheme.primary.withAlpha(230),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: context.colorScheme.primary.withAlpha(51),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(64),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.person_rounded,
              color: context.colorScheme.onPrimary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.buyerName,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onPrimary,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(38),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ID: ${widget.buyerId.substring(0, 8)}...',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onPrimary.withAlpha(230),
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildSummaryCards(List<MilkSale> sales) => Row(
    children: <Widget>[
      Expanded(
        child: _buildSummaryCard(
          title: 'Total Quantity',
          value: '${_calculateTotalQuantity(sales).toStringAsFixed(1)} L',
          icon: Icons.water_drop_rounded,
          color: const Color(0xFF3B82F6),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _buildSummaryCard(
          title: 'Total Amount',
          value: '₹${_calculateTotalAmount(sales).toStringAsFixed(2)}',
          icon: Icons.currency_rupee_rounded,
          color: const Color(0xFF10B981),
        ),
      ),
    ],
  );

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) => CustomContainer(
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withAlpha(77), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.outline,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 22,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildSaleCard(MilkSale sale) => CustomContainer(
    child: InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: context.colorScheme.outline.withAlpha(26),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.calendar_today_rounded,
                        size: 18,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('dd MMM yyyy').format(sale.date),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF10B981).withAlpha(51),
                    ),
                  ),
                  child: Text(
                    '₹${(sale.totalAmount ?? 0.0).toStringAsFixed(2)}',
                    style: context.textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF059669),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF3B82F6).withAlpha(51),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.water_drop_rounded,
                              size: 16,
                              color: Color(0xFF3B82F6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Quantity',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.outline,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${sale.quantityLitres.toStringAsFixed(1)} L',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3B82F6),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFF59E0B).withAlpha(51),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.currency_rupee_rounded,
                              size: 16,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Price/L',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.outline,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '₹${sale.pricePerLitre.toStringAsFixed(2)}',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF59E0B),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (sale.notes != null && sale.notes!.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.sticky_note_2_rounded,
                      size: 16,
                      color: context.colorScheme.outline,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        sale.notes!,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
