import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/widget/custom_container.dart';
import 'package:digital_dairy/features/cattle/presentation/widget/custom_container.dart';
import 'package:digital_dairy/features/sales/model/milk_sales_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuyerSalesScreen extends StatefulWidget {
  const BuyerSalesScreen({
    super.key,
    required this.buyerId,
    required this.buyerName,
  });

  final String buyerId;
  final String buyerName;

  @override
  State<BuyerSalesScreen> createState() => _BuyerSalesScreenState();
}

class _BuyerSalesScreenState extends State<BuyerSalesScreen> {
  late List<MilkSale> _sales;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  void _loadSales() {
    // TODO: Replace with actual API call
    // context.read<SalesCubit>().loadSalesByBuyer(widget.buyerId);

    // Dummy data for now
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _sales = _generateDummyData();
        _isLoading = false;
      });
    });
  }

  List<MilkSale> _generateDummyData() {
    return List.generate(
      15,
      (index) => MilkSale(
        id: 'sale_${index + 1}',
        userId: 'user_123',
        buyerId: widget.buyerId,
        date: DateTime.now().subtract(Duration(days: index * 2)),
        quantityLitres: 10.0 + (index * 2.5),
        pricePerLitre: 50.0 + (index * 0.5),
        totalAmount: (10.0 + (index * 2.5)) * (50.0 + (index * 0.5)),
        notes: index % 3 == 0 ? 'Morning collection' : null,
        createdAt: DateTime.now().subtract(Duration(days: index * 2)),
      ),
    );
  }

  double _calculateTotalQuantity() {
    return _sales.fold(0.0, (sum, sale) => sum + sale.quantityLitres);
  }

  double _calculateTotalAmount() {
    return _sales.fold(0.0, (sum, sale) => sum + (sale.totalAmount ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: CustomScaffoldContainer(
        child: CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    _buildBuyerInfoCard(),
                    const SizedBox(height: 16),
                    if (!_isLoading) _buildSummaryCards(),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_sales.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 80,
                        color: context.colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No sales found',
                        style: context.textTheme.titleLarge?.copyWith(
                          color: context.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start by adding a new sale',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final sale = _sales[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildSaleCard(sale),
                    );
                  }, childCount: _sales.length),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to add sale screen
          // context.push('/add-milk-sale', extra: {
          //   'id': widget.buyerId,
          //   'name': widget.buyerName,
          // });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Sale'),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      pinned: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios,
          color: context.colorScheme.onSurface,
          size: 25,
        ),
      ),
      title: Text(
        'Sales History',
        style: context.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: context.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildBuyerInfoCard() {
    return CustomContainer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              context.colorScheme.primary,
              context.colorScheme.primary.withAlpha(204),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: context.colorScheme.onPrimary,
                size: 28,
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
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Buyer ID: ${widget.buyerId}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onPrimary.withAlpha(204),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildSummaryCard(
            title: 'Total Quantity',
            value: '${_calculateTotalQuantity().toStringAsFixed(1)} L',
            icon: Icons.water_drop,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            title: 'Total Amount',
            value: '₹${_calculateTotalAmount().toStringAsFixed(2)}',
            icon: Icons.currency_rupee,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return CustomContainer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(51)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaleCard(MilkSale sale) {
    return CustomContainer(
      child: InkWell(
        onTap: () {
          // TODO: Navigate to sale details or edit
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(51),
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('dd MMM yyyy').format(sale.date),
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(26),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '₹${(sale.totalAmount ?? 0.0).toStringAsFixed(2)}',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.water_drop,
                      label: 'Quantity',
                      value: '${sale.quantityLitres.toStringAsFixed(1)} L',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.currency_rupee,
                      label: 'Price/L',
                      value: '₹${sale.pricePerLitre.toStringAsFixed(2)}',
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              if (sale.notes != null && sale.notes!.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest
                        .withAlpha(128),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.note_outlined,
                        size: 16,
                        color: context.colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          sale.notes!,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface,
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

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
