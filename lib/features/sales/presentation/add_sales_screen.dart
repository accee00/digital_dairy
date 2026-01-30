import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/utils/show_loading.dart';
import 'package:digital_dairy/core/widget/app_text_form_field.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/save_elevated_button.dart';
import 'package:digital_dairy/features/sales/cubit/sales_cubit.dart';
import 'package:digital_dairy/features/sales/model/buyer_model.dart';
import 'package:digital_dairy/features/sales/model/milk_sales_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

///
class AddMilkSaleScreen extends StatefulWidget {
  ///
  const AddMilkSaleScreen({super.key, this.buyer});

  ///
  final Map<String, dynamic>? buyer;

  @override
  State<AddMilkSaleScreen> createState() => _AddMilkSaleScreenState();
}

class _AddMilkSaleScreenState extends State<AddMilkSaleScreen> {
  bool isEdit = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _buyerController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedBuyerId;
  double? _calculatedTotal;

  @override
  void initState() {
    super.initState();
    logInfo('BuyerId ${widget.buyer?['id']}');
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
    _quantityController.addListener(_calculateTotal);
    _priceController.addListener(_calculateTotal);
  }

  @override
  void dispose() {
    _buyerController.dispose();
    _dateController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    final double? quantity = double.tryParse(_quantityController.text);
    final double? price = double.tryParse(_priceController.text);

    if (quantity != null && price != null) {
      setState(() {
        _calculatedTotal = quantity * price;
      });
    } else {
      setState(() {
        _calculatedTotal = null;
      });
    }
  }

  void _addMilkSale() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedBuyerId == null && widget.buyer == null) {
      showAppSnackbar(
        context,
        message: context.strings.milkSaleSelectBuyerError,
        type: SnackbarType.error,
      );
      return;
    }

    showLoading(context);
    final MilkSale milkSale = MilkSale(
      buyerId: widget.buyer != null
          ? widget.buyer!['id'].toString()
          : _selectedBuyerId!,
      date: _selectedDate,
      quantityLitres: double.parse(_quantityController.text.trim()),
      pricePerLitre: double.parse(_priceController.text.trim()),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: DateTime.now(),
    );
    logInfo('milk sale model presentation $milkSale');
    context.read<SalesCubit>().addSales(milkSale);
  }

  @override
  Widget build(BuildContext context) => BlocListener<SalesCubit, SalesState>(
    listener: (BuildContext context, SalesState state) {
      if (state is SalesAddFailure) {
        showAppSnackbar(
          context,
          message: state.errorMsg,
          type: SnackbarType.error,
        );
        context.pop();
      }
      if (state is SaleAddSuccess) {
        showAppSnackbar(
          context,
          message: context.strings.milkSaleAddSuccess,
          type: SnackbarType.success,
        );
        context
          ..pop()
          ..pop();
      }
    },
    child: Scaffold(
      extendBody: true,
      backgroundColor: context.colorScheme.surface,
      body: CustomScaffoldContainer(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  isEdit
                      ? context.strings.milkSaleEditTitle
                      : context.strings.milkSaleAddTitle,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      // Buyer Selection Card
                      _buildBuyerCard(context),
                      const SizedBox(height: 20),

                      // Date Card
                      _buildDateCard(context),
                      const SizedBox(height: 20),

                      // Quantity & Price Card
                      _buildQuantityPriceCard(context),
                      const SizedBox(height: 20),

                      // Notes Card
                      _buildNotesCard(context),
                      const SizedBox(height: 32),

                      // Save Button
                      SaveElevatedButton(
                        label: context.strings.formSave,
                        onTap: _addMilkSale,
                        key: UniqueKey(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildBuyerCard(BuildContext context) {
    if (widget.buyer != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: context.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    context.strings.milkSaleBuyerLabel,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer.withAlpha(76),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: context.colorScheme.primary.withAlpha(51),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: context.colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.buyer!['name'].toString(),
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        context.strings.milkSaleSelected,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
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
    }

    return BlocBuilder<SalesCubit, SalesState>(
      builder: (BuildContext context, SalesState state) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: context.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    context.strings.milkSaleBuyerLabel,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.colorScheme.outline.withAlpha(80),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonFormField<String>(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  hint: Text(
                    context.strings.milkSaleChooseBuyerHint,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  initialValue: _selectedBuyerId,
                  items: state.buyers
                      .map(
                        (Buyer buyer) => DropdownMenuItem<String>(
                          value: buyer.id,
                          child: Text(buyer.name),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedBuyerId = value;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return context.strings.milkSaleSelectBuyerError;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.calendar_today_rounded,
                color: context.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                context.strings.milkSaleDateLabel,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                  _dateController.text = DateFormat(
                    'dd/MM/yyyy',
                  ).format(picked);
                });
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.colorScheme.outline.withAlpha(80),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.event_rounded, color: context.colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    _dateController.text.isNotEmpty
                        ? _dateController.text
                        : context.strings.milkSaleDateHint,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildQuantityPriceCard(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.water_drop_rounded,
                color: context.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                context.strings.milkSaleQuantityLabel,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextFormField(
            controller: _quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            labelText: context.strings.milkSaleQuantityInputLabel,
            hintText: context.strings.milkSaleQuantityHint,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return context.strings.milkSaleQuantityRequired;
              }
              if (double.tryParse(value) == null) {
                return context.strings.milkSaleInvalidNumber;
              }
              if (double.parse(value) <= 0) {
                return context.strings.milkSaleQuantityGreaterThanZero;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Icon(
                Icons.currency_rupee_rounded,
                color: context.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                context.strings.milkSalePriceLabel,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextFormField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            labelText: context.strings.milkSalePriceInputLabel,
            hintText: context.strings.milkSalePriceHint,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return context.strings.milkSalePriceRequired;
              }
              if (double.tryParse(value) == null) {
                return context.strings.milkSaleInvalidNumber;
              }
              if (double.parse(value) <= 0) {
                return context.strings.milkSalePriceGreaterThanZero;
              }
              return null;
            },
          ),
          if (_calculatedTotal != null) ...<Widget>[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer.withAlpha(76),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.colorScheme.primary.withAlpha(76),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    context.strings.milkSaleTotalAmount,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₹${_calculatedTotal!.toStringAsFixed(2)}',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );

  Widget _buildNotesCard(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.note_alt_outlined,
                color: context.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                context.strings.milkSaleNotesLabel,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextFormField(
            controller: _notesController,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            hintText: context.strings.milkSaleNotesHint,
          ),
        ],
      ),
    ),
  );
}
