import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';

import 'package:digital_dairy/core/widget/custom_container.dart';
import 'package:digital_dairy/core/widget/custom_text_feild.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';

import 'package:digital_dairy/features/cattle/presentation/widget/custom_container.dart';
import 'package:digital_dairy/features/milklog/cubit/milk_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

/// A StatefulWidget for adding milk production entries in the application.
class AddMilkScreen extends StatefulWidget {
  /// Initializes a new instance of the [AddMilkScreen] widget.
  const AddMilkScreen({super.key});

  @override
  State<AddMilkScreen> createState() => _AddMilkScreenState();
}

class _AddMilkScreenState extends State<AddMilkScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Form values
  String? _selectedCattleId;
  DateTime? _selectedDate;
  String _selectedShift = 'Morning';

  final List<String> _shifts = <String>['Morning', 'Evening'];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    return BlocListener<MilkCubit, MilkState>(
      listener: (BuildContext context, MilkState state) {
        if (state is MilkCreatedFailure) {
          showAppSnackbar(
            context,
            message: state.msg,
            type: SnackbarType.error,
          );
          context.pop();
        }
        if (state is MilkCreatedSuccess) {
          showAppSnackbar(
            context,
            message: 'Milk entry recorded successfully!',
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
              SliverAppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                ),
                title: Text(
                  'Add Milk Entry',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildSectionHeader(context, 'Cattle Selection'),
                        const SizedBox(height: 16),
                        _buildCattleSelectionSection(context),

                        const SizedBox(height: 32),
                        _buildSectionHeader(context, 'Milking Details'),
                        const SizedBox(height: 16),
                        _buildMilkingDetailsSection(context),

                        const SizedBox(height: 32),
                        _buildSectionHeader(context, 'Additional Information'),
                        const SizedBox(height: 16),
                        _buildAdditionalInfoSection(context),

                        const SizedBox(height: 40),
                        _buildActionButtons(context),
                        const SizedBox(height: 40),
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
  }

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
            color: context.colorScheme.onPrimaryContainer,
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
  Widget _buildCattleSelectionSection(BuildContext context) =>
      BlocBuilder<CattleCubit, CattleState>(
        builder: (BuildContext context, CattleState state) => CustomContainer(
          child: _buildDropdownField(
            context,
            'Select Cattle *',
            _selectedCattleId,
            state.cattle
                .map(
                  (Cattle e) => '${e.tagId} - ${e.name}',
                ) // show tag_id + name
                .toList(),
            (String? value) {
              final Cattle selectedCattle = state.cattle.firstWhere(
                (Cattle cattle) => '${cattle.tagId} - ${cattle.name}' == value,
              );
              setState(() {
                _selectedCattleId = selectedCattle.id;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please select a cattle';
              }
              return null;
            },
          ),
        ),
      );
  Widget _buildMilkingDetailsSection(BuildContext context) => CustomContainer(
    child: Column(
      children: <Widget>[
        _buildDateField(
          context,
          'Milking Date *',
          _selectedDate,
          (DateTime date) => setState(() => _selectedDate = date),
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now(),
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: _buildDropdownField(
                context,
                'Shift *',
                _selectedShift,
                _shifts,
                (String? value) => setState(() => _selectedShift = value!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                labelText: 'Quantity (Litres) *',
                controller: _quantityController,
                hintText: 'Enter quantity',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Quantity is required';
                  }
                  final double? quantity = double.tryParse(value);
                  if (quantity == null || quantity <= 0) {
                    return 'Enter valid quantity';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer.withAlpha(100),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Tip',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Record milk production immediately after milking for accuracy',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildAdditionalInfoSection(BuildContext context) => CustomContainer(
    child: Column(
      children: <Widget>[
        CustomTextField(
          labelText: 'Notes (Optional)',
          controller: _notesController,
          hintText:
              'Add notes about milk quality, cattle health, or any issues...',
          maxLines: 3,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest.withAlpha(100),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(100),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Common Notes:',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: <Widget>[
                  _buildQuickNoteChip(context, 'Good quality'),
                  _buildQuickNoteChip(context, 'Slightly low yield'),
                  _buildQuickNoteChip(context, 'Normal production'),
                  _buildQuickNoteChip(context, 'Cattle seems healthy'),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildQuickNoteChip(BuildContext context, String note) =>
      GestureDetector(
        onTap: () {
          if (_notesController.text.isEmpty) {
            _notesController.text = note;
          } else {
            _notesController.text = '${_notesController.text}, $note';
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer.withAlpha(150),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.colorScheme.primary.withAlpha(100),
            ),
          ),
          child: Text(
            note,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        ),
      );

  Widget _buildDropdownField(
    BuildContext context,
    String label,
    String? value,
    List<String> options,
    void Function(String?) onChanged, {
    String? Function(String?)? validator,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: context.colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.colorScheme.outline.withAlpha(100)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonFormField<String>(
          padding: const EdgeInsets.only(left: 10, right: 4),
          decoration: const InputDecoration(border: InputBorder.none),
          hint: Text(
            'Select ${label.toLowerCase().replaceAll(' *', '')}',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(100),
            ),
          ),
          value: value != null && options.contains(value) ? value : null,
          validator: validator,
          items: options
              .map(
                (String option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    ],
  );

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    void Function(DateTime) onDateSelected, {
    required DateTime firstDate,
    required DateTime lastDate,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: context.colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.colorScheme.outline.withAlpha(100)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: selectedDate != null
              ? Text(
                  _formatDate(selectedDate),
                  style: context.textTheme.bodyMedium,
                )
              : Text(
                  'Select Date',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurface.withAlpha(100),
                  ),
                ),
          trailing: Text('📅', style: TextStyle(fontSize: 20)),
          onTap: () async {
            final DateTime? date = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: firstDate,
              lastDate: lastDate,
            );
            if (date != null) {
              onDateSelected(date);
            }
          },
        ),
      ),
    ],
  );

  Widget _buildActionButtons(BuildContext context) => Column(
    children: <Widget>[
      SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _saveMilkEntry,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colorScheme.primary,
            foregroundColor: context.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('💾', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Save Milk Entry',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
    ],
  );

  String _formatDate(DateTime? date) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (date != null) {
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
    return '';
  }

  Future<void> _saveMilkEntry() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCattleId == null) {
      showAppSnackbar(
        context,
        message: 'Please select a cattle',
        type: SnackbarType.error,
      );
      return;
    }

    //   showLoading(context);

    //   final MilkEntry newMilkEntry = MilkEntry(
    //     userId: '', // passing from service file
    //     cattleId: _selectedCattleId!,
    //     date: _selectedDate!,
    //     shift: _selectedShift,
    //     quantityLitres: double.parse(_quantityController.text.trim()),
    //     notes: _notesController.text.trim(),
    //     createdAt: DateTime.now(),
    //   );

    //   if (!mounted) {
    //     return;
    //   }
    //   await context.read<MilkCubit>().createMilkEntry(newMilkEntry);
    //   if (!mounted) {
    //     return;
    //   }
    //   await context.read<MilkCubit>().getAllMilkEntries();
    // }
  }
}
