import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/utils/enums.dart';
import 'package:digital_dairy/core/utils/show_loading.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/custom_text_feild.dart';
import 'package:digital_dairy/core/widget/save_elevated_button.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:digital_dairy/features/cattle/presentation/widget/custom_container.dart';
import 'package:digital_dairy/features/milklog/cubit/milk_cubit.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A StatefulWidget for adding milk production entries in the application.
class AddMilkScreen extends StatefulWidget {
  /// Initializes a new instance of the [AddMilkScreen] widget.
  const AddMilkScreen({super.key, this.milkModel});

  ///
  final MilkModel? milkModel;
  @override
  State<AddMilkScreen> createState() => _AddMilkScreenState();
}

class _AddMilkScreenState extends State<AddMilkScreen> {
  late MilkModel _editMilkModel;
  bool get isEdit => widget.milkModel != null;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Form values
  String? _selectedCattleId;
  DateTime? _selectedDate;
  ShiftType _selectedShift = ShiftType.morning;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _editMilkModel = widget.milkModel!;
      _selectedCattleId = _editMilkModel.cattleId;
      _selectedDate = _editMilkModel.date;
      _selectedShift = _editMilkModel.shift;
      _quantityController.text = _editMilkModel.quantityInLiter.toString();
      _notesController.text = _editMilkModel.notes;
    } else {
      _selectedDate = DateTime.now();
    }
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
        if (state is MilkFailure) {
          showAppSnackbar(
            context,
            message: state.message,
            type: SnackbarType.error,
          );
          context.pop();
        }
        if (state is MilkSuccess) {
          showAppSnackbar(
            context,
            message: isEdit
                ? context.strings.milkEntryUpdated
                : context.strings.milkEntryRecorded,
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
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: colorScheme.onSurface,
                    size: 25,
                  ),
                ),
                title: Text(
                  isEdit
                      ? context.strings.milkEditEntry
                      : context.strings.milkAddEntry,
                  style: context.textTheme.headlineLarge?.copyWith(
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
                        _buildSectionHeader(
                          context,
                          context.strings.milkCattleSelection,
                        ),
                        const SizedBox(height: 5),
                        _buildCattleSelectionSection(context),

                        const SizedBox(height: 15),
                        _buildSectionHeader(
                          context,
                          context.strings.milkMilkingDetails,
                        ),
                        const SizedBox(height: 5),
                        _buildMilkingDetailsSection(context),

                        const SizedBox(height: 15),
                        _buildSectionHeader(
                          context,
                          context.strings.milkAdditionalInfo,
                        ),
                        const SizedBox(height: 5),
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

  Widget _buildSectionHeader(BuildContext context, String title) => Text(
    title,
    style: context.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: context.colorScheme.onSurface,
    ),
  );

  Widget _buildCattleSelectionSection(BuildContext context) =>
      BlocBuilder<CattleCubit, CattleState>(
        builder: (BuildContext context, CattleState state) {
          String? selectedCattleDisplay;
          if (_selectedCattleId != null) {
            final Cattle cattle = state.cattle.firstWhere(
              (Cattle c) => c.id == _selectedCattleId,
              orElse: () => state.cattle.first,
            );
            selectedCattleDisplay = '${cattle.tagId} - ${cattle.name}';
          }
          return CustomContainer(
            child: _buildDropdownField(
              context,
              context.strings.milkSelectCattle,
              selectedCattleDisplay,
              state.cattle
                  .map(
                    (Cattle e) => '${e.tagId} - ${e.name}',
                  ) // show tag_id + name
                  .toList(),
              (String? value) {
                final Cattle selectedCattle = state.cattle.firstWhere(
                  (Cattle cattle) =>
                      '${cattle.tagId} - ${cattle.name}' == value,
                );
                setState(() {
                  _selectedCattleId = selectedCattle.id;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return context.strings.milkSelectCattleError;
                }
                return null;
              },
            ),
          );
        },
      );

  Widget _buildMilkingDetailsSection(BuildContext context) => CustomContainer(
    child: Column(
      children: <Widget>[
        _buildDateField(
          context,
          context.strings.milkMilkingDate,
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
                context.strings.milkShift,
                _selectedShift.value,
                <String>[context.strings.morning, context.strings.evening],
                (String? value) =>
                    setState(() => _selectedShift = ShiftType.from(value!)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                height: 52,
                labelText: context.strings.milkQuantity,
                controller: _quantityController,
                hintText: context.strings.milkEnterQuantity,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.strings.milkQuantityRequired;
                  }
                  final double? quantity = double.tryParse(value);
                  if (quantity == null || quantity <= 0) {
                    return context.strings.milkEnterValidQuantity;
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
                context.strings.milkTip,
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
                context.strings.milkTipText,
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
          labelText: context.strings.milkNotes,
          controller: _notesController,
          hintText: context.strings.milkNotesHint,
          maxLines: 3,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
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
                context.strings.milkCommonNotes,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: <Widget>[
                  _buildQuickNoteChip(context, context.strings.milkGoodQuality),
                  _buildQuickNoteChip(
                    context,
                    context.strings.milkSlightlyLowYield,
                  ),
                  _buildQuickNoteChip(
                    context,
                    context.strings.milkNormalProduction,
                  ),
                  _buildQuickNoteChip(
                    context,
                    context.strings.milkCattleSeemsHealthy,
                  ),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: context.colorScheme.onError.withAlpha(100),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.colorScheme.primary.withAlpha(100),
            ),
          ),
          child: Text(
            note,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.primary,
              fontSize: 14,
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
          borderRadius: BorderRadius.circular(13),
        ),
        child: DropdownButtonFormField<String>(
          padding: const EdgeInsets.only(left: 10, right: 4),
          decoration: const InputDecoration(border: InputBorder.none),
          hint: Text(
            label.toLowerCase().replaceAll(' *', ''),
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(100),
            ),
          ),
          initialValue: value != null && options.contains(value) ? value : null,
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
                  context.strings.milkSelectDate,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurface.withAlpha(100),
                  ),
                ),
          trailing: const Icon(Icons.calendar_month),
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
      SaveElevatedButton(
        key: UniqueKey(),
        label: isEdit
            ? context.strings.milkUpdateEntry
            : context.strings.milkSaveEntry,
        onTap: _saveMilkEntry,
      ),
      const SizedBox(height: 12),
    ],
  );

  String _formatDate(DateTime? date) {
    if (date != null) {
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
    return '';
  }

  void _saveMilkEntry() {
    if (_selectedCattleId == null) {
      showAppSnackbar(
        context,
        message: context.strings.milkSelectCattleError,
        type: SnackbarType.error,
      );
      return;
    }
    if (_quantityController.text.trim().isEmpty) {
      showAppSnackbar(
        context,
        message: context.strings.milkQuantityRequired,
        type: SnackbarType.error,
      );
      return;
    }
    showLoading(context);

    final MilkModel newMilkEntry = MilkModel(
      id: isEdit ? _editMilkModel.id : null,
      userId: isEdit ? _editMilkModel.userId : null,
      cattleId: _selectedCattleId!,
      date: isEdit ? _editMilkModel.date : _selectedDate!,
      shift: _selectedShift,
      notes: _notesController.text.trim(),
      createdAt: DateTime.now(),
      quantityInLiter: double.parse(_quantityController.text.trim()),
    );
    isEdit
        ? context.read<MilkCubit>().editMilk(newMilkEntry)
        : context.read<MilkCubit>().addMilkLog(newMilkEntry);
  }
}
