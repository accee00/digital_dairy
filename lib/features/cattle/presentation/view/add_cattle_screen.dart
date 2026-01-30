import 'dart:io';

import 'package:digital_dairy/core/di/init_di.dart';
import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/utils/show_loading.dart';
import 'package:digital_dairy/core/widget/app_text_form_field.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/save_elevated_button.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:digital_dairy/services/cattle_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// A StatefulWidget for adding cattle details in the application.
class AddCattleScreen extends StatefulWidget {
  /// Initializes a new instance of the [AddCattleScreen] widget.
  const AddCattleScreen({super.key, this.cattle});

  ///
  final Cattle? cattle;
  @override
  State<AddCattleScreen> createState() => _AddCattleScreenState();
}

class _AddCattleScreenState extends State<AddCattleScreen> {
  bool get isEdit => widget.cattle != null;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Image
  File? _selectedImage;

  // Form values
  String _selectedBreed = 'Holstein';
  String _selectedGender = 'Female';
  String _selectedStatus = 'Active';
  DateTime? _selectedDob;
  DateTime? _selectedCalvingDate;

  final List<String> _breeds = <String>[
    'Holstein',
    'Jersey',
    'Gir',
    'Sahiwal',
    'Red Sindhi',
    'Tharparkar',
    'Rathi',
    'Hariana',
    'Ongole',
    'Kankrej',
    'Cross Breed',
    'Other',
  ];
  final List<String> _genders = <String>['Female', 'Male'];
  final List<String> _statuses = <String>[
    'Active',
    'Pregnant',
    'Sick',
    'Dry',
    'Sold',
  ];
  @override
  void initState() {
    _initializeCattle();
    super.initState();
  }

  void _initializeCattle() {
    if (isEdit) {
      logInfo('Is edit is true');
      _nameController.text = widget.cattle!.name;
      _tagController.text = widget.cattle!.tagId;
      _notesController.text = widget.cattle!.notes;
      _selectedBreed = widget.cattle!.breed;
      _selectedGender = widget.cattle!.gender;
      _selectedStatus = widget.cattle!.status;
      _selectedDob = widget.cattle!.dob;
      _selectedCalvingDate = widget.cattle!.calvingDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tagController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    return BlocListener<CattleCubit, CattleState>(
      listener: (BuildContext context, CattleState state) {
        if (state is CattleCreatedFailure) {
          showAppSnackbar(
            context,
            message: state.msg,
            type: SnackbarType.error,
          );
          context.pop();
        }
        if (state is CattleUpdateFailure) {
          showAppSnackbar(
            context,
            message: state.msg,
            type: SnackbarType.error,
          );
          context.pop();
        }
        if (state is CattleCreatedSuccess || state is CattleUpdatedSuccess) {
          showAppSnackbar(
            context,
            message: isEdit
                ? context.strings.cattleUpdatedSuccess
                : context.strings.cattleRegisteredSuccess,
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
                        ? context.strings.cattleEntryEdit
                        : context.strings.addCattleTitle,
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

                        // Physical Details Card
                        _buildPhysicalDetailsCard(context),
                        const SizedBox(height: 20),

                        // Dates Card
                        _buildDatesCard(context),
                        const SizedBox(height: 20),

                        // Notes Card
                        _buildNotesCard(context),
                        const SizedBox(height: 32),

                        // Save Button
                        SaveElevatedButton(
                          key: UniqueKey(),
                          label: context.strings.saveCattleButton,
                          onTap: _saveCattle,
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
                  Icons.pets_rounded,
                  color: context.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                context.strings.cattleBasicInfo,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            controller: _nameController,
            labelText: context.strings.cattleNameLabel,
            hintText: context.strings.cattleNameHint,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return context.strings.cattleNameRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            controller: _tagController,
            labelText: context.strings.tagIdLabel,
            hintText: context.strings.tagIdHint,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return context.strings.tagIdRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildImagePickerSection(context),
        ],
      ),
    ),
  );

  Widget _buildPhysicalDetailsCard(BuildContext context) => Card(
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
                  Icons.info_outline_rounded,
                  color: context.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                context.strings.physicalDetails,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildModernDropdownField(
            context,
            context.strings.breedLabel,
            _selectedBreed,
            _breeds,
            (String? value) => setState(() => _selectedBreed = value!),
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildModernDropdownField(
                  context,
                  context.strings.genderLabel,
                  _selectedGender,
                  _genders,
                  (String? value) => setState(() => _selectedGender = value!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModernDropdownField(
                  context,
                  context.strings.statusLabel,
                  _selectedStatus,
                  _statuses,
                  (String? value) => setState(() => _selectedStatus = value!),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildDatesCard(BuildContext context) => Card(
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
                context.strings.importantDates,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildModernDateField(
            context,
            context.strings.dobLabel,
            _selectedDob,
            (DateTime date) => setState(() => _selectedDob = date),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          ),
          if (_selectedGender == 'Female') ...<Widget>[
            const SizedBox(height: 16),
            _buildModernDateField(
              context,
              context.strings.calvingDateLabel,
              _selectedCalvingDate,
              (DateTime date) => setState(() => _selectedCalvingDate = date),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
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
                      context.strings.calvingDateHint,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
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
                context.strings.additionalInfo,
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
            hintText: context.strings.notesHint,
          ),
        ],
      ),
    ),
  );

  Widget _buildModernDropdownField(
    BuildContext context,
    String label,
    String value,
    List<String> options,
    void Function(String?) onChanged,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.colorScheme.outline.withAlpha(80)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: DropdownButtonFormField<String>(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
          initialValue: value,
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

  Widget _buildModernDateField(
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
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 8),
      InkWell(
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
                selectedDate != null
                    ? _formatDate(selectedDate, context)
                    : context.strings.selectDate,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  String _formatDate(DateTime? date, BuildContext context) {
    if (date == null) {
      return '';
    }

    final String monthName = _getLocalizedMonth(date.month, context);

    return '${date.day} $monthName ${date.year}';
  }

  String _getLocalizedMonth(int month, BuildContext context) {
    switch (month) {
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

  Future<void> _saveCattle() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showLoading(context);

    String imageUrl = widget.cattle?.imageUrl ?? '';

    if (_selectedImage != null) {
      final Either<Failure, String> response =
          await serviceLocator<CattleService>().uploadImage(_selectedImage!);

      response.fold(
        (_) => showAppSnackbar(
          context,
          message: context.strings.failToUploadImage,
        ),
        (String url) => imageUrl = url,
      );
    }

    final Cattle newCattle = Cattle(
      id: isEdit ? widget.cattle!.id : null,
      userId: widget.cattle?.userId ?? '',
      name: _nameController.text.trim(),
      tagId: _tagController.text.trim(),
      imageUrl: imageUrl,
      breed: _selectedBreed,
      gender: _selectedGender,
      dob: _selectedDob,
      calvingDate: _selectedCalvingDate,
      status: _selectedStatus,
      notes: _notesController.text.trim(),
      createdAt: widget.cattle?.createdAt ?? DateTime.now(),
    );

    if (!mounted) {
      return;
    }

    if (isEdit) {
      await context.read<CattleCubit>().updateCattle(newCattle);
    } else {
      await context.read<CattleCubit>().createCattle(newCattle);
    }

    if (!mounted) {
      return;
    }
  }

  Widget _buildImagePickerSection(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        context.strings.cattlePhotoLabel,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: () => _pickImage(ImageSource.gallery),
        child: Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(80),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: _selectedImage != null
              ? Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colorScheme.error,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: context.colorScheme.onError,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : isEdit && widget.cattle!.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    widget.cattle!.imageUrl!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add_a_photo,
                      size: 48,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.strings.tapToAddPhoto,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    ],
  );

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context,
          message: '${context.strings.errorPickingImage} $e',
          type: SnackbarType.error,
        );
      }
    }
  }
}
