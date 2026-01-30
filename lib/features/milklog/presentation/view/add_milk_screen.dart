import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/utils/enums.dart';
import 'package:digital_dairy/core/utils/show_loading.dart';
import 'package:digital_dairy/core/widget/app_text_form_field.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/save_elevated_button.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
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
        backgroundColor: colorScheme.surface,
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
                        ? context.strings.milkEditEntry
                        : context.strings.milkAddEntry,
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
                        // Cattle Selection Card
                        _buildCattleSelectionCard(context),
                        const SizedBox(height: 20),

                        // Date & Shift Selection
                        _buildDateShiftCard(context),
                        const SizedBox(height: 20),

                        // Quantity Input
                        _buildQuantityCard(context),
                        const SizedBox(height: 20),

                        // Notes Section
                        _buildNotesCard(context),
                        const SizedBox(height: 32),

                        // Save Button
                        SaveElevatedButton(
                          key: UniqueKey(),
                          label: isEdit
                              ? context.strings.milkUpdateEntry
                              : context.strings.milkSaveEntry,
                          onTap: _saveMilkEntry,
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
  }

  Widget _buildCattleSelectionCard(
    BuildContext context,
  ) => BlocBuilder<CattleCubit, CattleState>(
    builder: (BuildContext context, CattleState state) => Card(
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
                    Icons.pets_rounded,
                    color: context.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  context.strings.milkSelectCattle,
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
                  context.strings.milkSelectCattle,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                initialValue:
                    _selectedCattleId != null &&
                        state.cattle.any(
                          (Cattle c) => c.id == _selectedCattleId,
                        )
                    ? _selectedCattleId
                    : null,
                items: state.cattle
                    .map(
                      (Cattle cattle) => DropdownMenuItem<String>(
                        value: cattle.id,
                        child: Row(
                          children: <Widget>[
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
                                cattle.tagId,
                                style: context.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      context.colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              cattle.name,
                              style: context.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedCattleId = value;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return context.strings.milkSelectCattleError;
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

  Widget _buildDateShiftCard(BuildContext context) => Card(
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
                context.strings.milkMilkingDate,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final DateTime? date = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() => _selectedDate = date);
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
                    _selectedDate != null
                        ? _formatDate(_selectedDate)
                        : context.strings.milkSelectDate,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Icon(
                Icons.wb_twilight_rounded,
                color: context.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                context.strings.milkShift,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildShiftButton(
                  context,
                  context.strings.morning,
                  Icons.wb_sunny_rounded,
                  ShiftType.morning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildShiftButton(
                  context,
                  context.strings.evening,
                  Icons.nightlight_round,
                  ShiftType.evening,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildShiftButton(
    BuildContext context,
    String label,
    IconData icon,
    ShiftType shift,
  ) {
    final bool isSelected = _selectedShift == shift;
    return InkWell(
      onTap: () => setState(() => _selectedShift = shift),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primaryContainer
              : context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.outline.withAlpha(80),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: isSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityCard(BuildContext context) => Card(
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
                context.strings.milkQuantity,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.0',
                    hintStyle: context.textTheme.headlineMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant.withAlpha(
                        100,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: context.colorScheme.outline.withAlpha(80),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: context.colorScheme.outline.withAlpha(80),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: context.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(20),
                  ),
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
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'L',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer.withAlpha(50),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: context.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.strings.milkTipText,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
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
                context.strings.milkNotes,
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
            hintText: context.strings.milkNotesHint,
          ),
          const SizedBox(height: 16),
          Text(
            context.strings.milkCommonNotes,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
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
  );

  Widget _buildQuickNoteChip(BuildContext context, String note) => InkWell(
    onTap: () {
      if (_notesController.text.isEmpty) {
        _notesController.text = note;
      } else {
        _notesController.text = '${_notesController.text}, $note';
      }
    },
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: context.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        note,
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
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
