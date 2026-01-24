import 'dart:io';

import 'package:digital_dairy/core/di/init_di.dart';
import 'package:digital_dairy/core/exceptions/failure.dart';
import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/logger/logger.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/utils/show_loading.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/custom_text_feild.dart';
import 'package:digital_dairy/core/widget/save_elevated_button.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:digital_dairy/features/cattle/presentation/widget/custom_container.dart';
import 'package:digital_dairy/services/cattle_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                ? 'Cattle updated successfully!'
                : 'Cattle registered successfully!',
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
                    size: 25,
                    Icons.arrow_back_ios,
                    color: colorScheme.onSurface,
                  ),
                ),
                title: Text(
                  'Add Cattle',
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
                          'Basic Information',
                          Icons.info,
                        ),
                        const SizedBox(height: 5),
                        _buildBasicInfoSection(context),

                        const SizedBox(height: 10),
                        _buildSectionHeader(
                          context,
                          'Physical Details',
                          Icons.pets,
                        ),
                        const SizedBox(height: 5),
                        _buildPhysicalDetailsSection(context),

                        const SizedBox(height: 10),
                        _buildSectionHeader(
                          context,
                          'Important Dates',
                          Icons.calendar_today,
                        ),
                        const SizedBox(height: 5),
                        _buildDatesSection(context),

                        const SizedBox(height: 10),
                        _buildSectionHeader(
                          context,
                          'Additional Information',
                          Icons.note,
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

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) => Text(
    title,
    style: context.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: context.colorScheme.onSurface,
    ),
  );

  Widget _buildBasicInfoSection(BuildContext context) => CustomContainer(
    child: Column(
      children: <Widget>[
        CustomTextField(
          labelText: 'Cattle Name *',
          controller: _nameController,
          hintText: 'Enter cattle name (e.g., Ganga, Kamdhenu)',
          suffixIcon: const Icon(Icons.pets),
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return 'Cattle name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          labelText: 'Tag ID *',
          controller: _tagController,
          hintText: 'Enter unique tag ID (e.g., C001, TAG123)',
          suffixIcon: const Icon(Icons.qr_code),
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return 'Tag ID is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildImagePickerSection(context),
      ],
    ),
  );

  Widget _buildPhysicalDetailsSection(BuildContext context) => CustomContainer(
    child: Column(
      children: <Widget>[
        _buildDropdownField(
          context,
          'Breed',
          _selectedBreed,
          _breeds,
          Icons.category,
          (String? value) => setState(() => _selectedBreed = value!),
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: _buildDropdownField(
                context,
                'Gender',
                _selectedGender,
                _genders,
                _selectedGender == 'Female' ? Icons.female : Icons.male,
                (String? value) => setState(() => _selectedGender = value!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdownField(
                context,
                'Status',
                _selectedStatus,
                _statuses,
                Icons.health_and_safety,
                (String? value) => setState(() => _selectedStatus = value!),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildDatesSection(BuildContext context) => CustomContainer(
    child: Column(
      children: <Widget>[
        _buildDateField(
          context,
          'Date of Birth',
          _selectedDob,
          Icons.cake,
          (DateTime date) => setState(() => _selectedDob = date),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        ),
        const SizedBox(height: 16),
        if (_selectedGender == 'Female') ...<Widget>[
          _buildDateField(
            context,
            'Expected Calving Date',
            _selectedCalvingDate,
            Icons.baby_changing_station,
            (DateTime date) => setState(() => _selectedCalvingDate = date),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
          ),
          const SizedBox(height: 8),
          Text(
            'Leave empty if not applicable or unknown',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(150),
            ),
          ),
        ],
      ],
    ),
  );

  Widget _buildAdditionalInfoSection(BuildContext context) => CustomContainer(
    child: CustomTextField(
      labelText: 'Notes (Optional)',
      controller: _notesController,
      hintText: 'Add any additional notes about this cattle...',
      suffixIcon: const Icon(Icons.notes_rounded),
      maxLines: 4,
      textInputAction: TextInputAction.done,
    ),
  );

  Widget _buildDropdownField(
    BuildContext context,
    String label,
    String value,
    List<String> options,
    IconData icon,
    void Function(String?) onChanged,
  ) => Column(
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
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: context.colorScheme.primary.withAlpha(100),
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

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    IconData icon,
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
          trailing: const Icon(Icons.calendar_month),
          onTap: () async {
            final DateTime? date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
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
        label: 'Save Cattle',
        onTap: _saveCattle,
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
        (_) => showAppSnackbar(context, message: 'Fail to upload image'),
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
        'Cattle Photo (Optional)',
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: context.colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 8),

      GestureDetector(
        onTap: () => _pickImage(ImageSource.gallery),
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(100),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _selectedImage != null
              ? Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
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
                  borderRadius: BorderRadius.circular(10),
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
                      color: context.colorScheme.onSurface.withAlpha(120),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap to add cattle photo',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurface.withAlpha(150),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: context.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
