import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/utils/show_loading.dart';
import 'package:digital_dairy/core/widget/custom_container.dart';
import 'package:digital_dairy/core/widget/custom_text_feild.dart';
import 'package:digital_dairy/core/widget/save_elevated_button.dart';
import 'package:digital_dairy/features/cattle/presentation/widget/custom_container.dart';
import 'package:digital_dairy/features/sales/cubit/sales_cubit.dart';
import 'package:digital_dairy/features/sales/model/buyer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddBuyerScreen extends StatefulWidget {
  const AddBuyerScreen({super.key});

  @override
  State<AddBuyerScreen> createState() => _AddBuyerScreenState();
}

class _AddBuyerScreenState extends State<AddBuyerScreen> {
  bool isEdit = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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
          message: 'Buyer added successfully!',
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
                    children: <Widget>[
                      _buildSectionHeader(context, 'Name'),
                      const SizedBox(height: 10),
                      _buildInputFeild(
                        controller: _nameController,
                        labelText: 'Buyer Name',
                        hintText: 'Shaym Singh',
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter buyer name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildSectionHeader(context, 'Contact'),
                      const SizedBox(height: 10),
                      _buildInputFeild(
                        controller: _contactController,
                        keyboardType: TextInputType.phone,
                        labelText: 'Contact Number',
                        hintText: '9023812023',
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter contact number';
                          }
                          if (value.length < 10) {
                            return 'Invalid contact number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildSectionHeader(context, 'Address'),
                      const SizedBox(height: 10),
                      _buildInputFeild(
                        controller: _addressController,
                        labelText: 'Address',
                        hintText:
                            'Akshya Nagar 1st Block 1st Cross, Rammurthy nagar, Bangalore-560016',
                        maxLine: 3,
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 60),
                      SaveElevatedButton(
                        label: 'Save',
                        onTap: _addBuyer,
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

  CustomContainer _buildInputFeild({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLine = 1,
    String? Function(String?)? validator,
  }) => CustomContainer(
    child: CustomTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      keyboardType: keyboardType,
      maxLines: maxLine,
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
      isEdit ? 'Edit Buyer' : 'Add Buyer',
      style: context.textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.colorScheme.onSurface,
      ),
    ),
  );

  Widget _buildSectionHeader(BuildContext context, String title) => Row(
    children: <Widget>[
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title.substring(0, 1),
          style: TextStyle(
            color: context.colorScheme.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: context.colorScheme.onSurface,
        ),
      ),
    ],
  );
}
