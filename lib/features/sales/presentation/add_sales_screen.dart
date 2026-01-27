import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/utils/show_loading.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/custom_text_feild.dart';
import 'package:digital_dairy/core/widget/save_elevated_button.dart';
import 'package:digital_dairy/features/cattle/presentation/widget/custom_container.dart';
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
      body: CustomScaffoldContainer(
        child: CustomScrollView(
          slivers: <Widget>[
            _appbar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (widget.buyer != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildSectionHeader(
                              context,
                              context.strings.milkSaleBuyerLabel,
                            ),
                            const SizedBox(height: 10),
                            CustomContainer(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.primaryContainer
                                      .withAlpha(76),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: context.colorScheme.primary
                                        .withAlpha(51),
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
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  context.colorScheme.onSurface,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.colorScheme.primary
                                            .withAlpha(51),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        context.strings.milkSaleSelected,
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                              color:
                                                  context.colorScheme.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildSectionHeader(
                              context,
                              context.strings.milkSaleBuyerLabel,
                            ),
                            const SizedBox(height: 10),
                            _buildBuyerDropdown(),
                          ],
                        ),
                      const SizedBox(height: 20),
                      _buildSectionHeader(
                        context,
                        context.strings.milkSaleDateLabel,
                      ),
                      const SizedBox(height: 10),
                      _buildDatePicker(context),
                      const SizedBox(height: 20),
                      _buildSectionHeader(
                        context,
                        context.strings.milkSaleQuantityLabel,
                      ),
                      const SizedBox(height: 10),
                      _buildInputFeild(
                        controller: _quantityController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
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
                            return context
                                .strings
                                .milkSaleQuantityGreaterThanZero;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildSectionHeader(
                        context,
                        context.strings.milkSalePriceLabel,
                      ),
                      const SizedBox(height: 10),
                      _buildInputFeild(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
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
                            color: context.colorScheme.primaryContainer
                                .withAlpha(76),
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
                                  color: context.colorScheme.onSurface,
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
                      const SizedBox(height: 20),
                      _buildSectionHeader(
                        context,
                        context.strings.milkSaleNotesLabel,
                      ),
                      const SizedBox(height: 10),
                      _buildInputFeild(
                        controller: _notesController,
                        labelText: context.strings.milkSaleNotesInputLabel,
                        hintText: context.strings.milkSaleNotesHint,
                        maxLine: 3,
                      ),
                      const SizedBox(height: 60),
                      SaveElevatedButton(
                        label: context.strings.formSave,
                        onTap: _addMilkSale,
                        key: UniqueKey(),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildBuyerDropdown() => BlocBuilder<SalesCubit, SalesState>(
    builder: (BuildContext context, SalesState state) => CustomContainer(
      child: DropdownButtonFormField<String>(
        initialValue: _selectedBuyerId,
        hint: Text(
          context.strings.milkSaleChooseBuyerHint,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(100),
          ),
        ),
        decoration: const InputDecoration(border: InputBorder.none),
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
  );

  Widget _buildDatePicker(BuildContext context) => CustomContainer(
    child: CustomTextField(
      controller: _dateController,
      labelText: context.strings.milkSaleDateInputLabel,
      hintText: context.strings.milkSaleDateHint,
      readOnly: true,
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
            _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
          });
        }
      },
      suffixIcon: Icon(
        Icons.calendar_today,
        color: context.colorScheme.primary,
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return context.strings.milkSaleDateRequired;
        }
        return null;
      },
    ),
  );

  CustomContainer _buildInputFeild({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLine = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) => CustomContainer(
    child: CustomTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      keyboardType: keyboardType,
      maxLines: maxLine,
      readOnly: readOnly,
      onTap: onTap,
      suffixIcon: suffixIcon,
      validator: validator,
    ),
  );

  SliverAppBar _appbar(BuildContext context) => SliverAppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back_ios,
        color: context.colorScheme.onSurface,
        size: 25,
      ),
    ),
    title: Text(
      isEdit
          ? context.strings.milkSaleEditTitle
          : context.strings.milkSaleAddTitle,
      style: context.textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.colorScheme.onSurface,
      ),
    ),
  );

  Widget _buildSectionHeader(BuildContext context, String title) => Text(
    title,
    style: context.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: context.colorScheme.onSurface,
    ),
  );
}
