import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/utils/show_loading.dart';
import 'package:digital_dairy/core/widget/app_text_form_field.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/save_elevated_button.dart';
import 'package:digital_dairy/features/sales/cubit/sales_cubit.dart';
import 'package:digital_dairy/features/sales/model/buyer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

///
class AddBuyerScreen extends StatefulWidget {
  ///
  const AddBuyerScreen({this.buyer, super.key});

  ///
  final Buyer? buyer;

  @override
  State<AddBuyerScreen> createState() => _AddBuyerScreenState();
}

class _AddBuyerScreenState extends State<AddBuyerScreen> {
  late bool isEdit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isEdit = widget.buyer != null;

    if (isEdit) {
      _nameController.text = widget.buyer!.name;
      _contactController.text = widget.buyer!.contact;
      _addressController.text = widget.buyer!.address;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<SalesCubit, SalesState>(
    listener: (BuildContext context, SalesState state) {
      if (state is BuyerAddedFailure) {
        showAppSnackbar(
          context,
          message: state.errorMsg,
          type: SnackbarType.error,
        );
        context.pop();
      }
      if (state is BuyerAddedSuccess) {
        showAppSnackbar(
          context,
          message: context.strings.buyerAddedSuccess,
          type: SnackbarType.success,
        );
        context
          ..pop()
          ..pop();
      }
      if (state is BuyerUpdateFailure) {
        showAppSnackbar(
          context,
          message: state.errorMsg,
          type: SnackbarType.error,
        );
        context.pop();
      }
      if (state is BuyerUpdateSuccess) {
        showAppSnackbar(
          context,
          message: context.strings.buyerUpdatedSuccess,
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
                      ? context.strings.buyerEditTitle
                      : context.strings.buyerAddTitle,
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
                      // Basic Info Card
                      _buildBasicInfoCard(context),
                      const SizedBox(height: 20),

                      // Contact Card
                      _buildContactCard(context),
                      const SizedBox(height: 20),

                      // Address Card
                      _buildAddressCard(context),
                      const SizedBox(height: 32),

                      // Save Button
                      SaveElevatedButton(
                        label: isEdit
                            ? context.strings.buyerUpdate
                            : context.strings.buyerSave,
                        onTap: isEdit ? _updateBuyer : _addBuyer,
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

  Widget _buildBasicInfoCard(BuildContext context) => Card(
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
                context.strings.buyerNameLabel,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            controller: _nameController,
            hintText: context.strings.buyerNameHint,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return context.strings.buyerNameRequired;
              }
              return null;
            },
          ),
        ],
      ),
    ),
  );

  Widget _buildContactCard(BuildContext context) => Card(
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
                  Icons.phone_rounded,
                  color: context.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                context.strings.buyerContactLabel,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            controller: _contactController,
            keyboardType: TextInputType.phone,
            labelText: context.strings.buyerContactLabel,
            hintText: context.strings.buyerContactHint,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return context.strings.buyerContactRequired;
              }
              if (value.length < 10) {
                return context.strings.buyerInvalidContact;
              }
              return null;
            },
          ),
        ],
      ),
    ),
  );

  Widget _buildAddressCard(BuildContext context) => Card(
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
                  Icons.location_on_rounded,
                  color: context.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                context.strings.buyerAddressLabel,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            controller: _addressController,
            maxLines: 3,
            labelText: context.strings.buyerAddressLabel,
            hintText: context.strings.buyerAddressHint,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return context.strings.buyerAddressRequired;
              }
              return null;
            },
          ),
        ],
      ),
    ),
  );

  void _addBuyer() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    showLoading(context);
    final Buyer buyer = Buyer(
      name: _nameController.text.trim(),
      createdAt: DateTime.now(),
      contact: _contactController.text.trim(),
      address: _addressController.text.trim(),
    );
    logInfo('buyer model presentation $buyer');
    context.read<SalesCubit>().addBuyer(buyer);
  }

  void _updateBuyer() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    showLoading(context);
    final Buyer updatedBuyer = widget.buyer!.copyWith(
      name: _nameController.text.trim(),
      contact: _contactController.text.trim(),
      address: _addressController.text.trim(),
    );
    logInfo('updated buyer model presentation $updatedBuyer');
    context.read<SalesCubit>().updateBuyer(updatedBuyer);
  }
}
