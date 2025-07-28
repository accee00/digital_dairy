import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/widget/custom_text_feild.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddCattleScreen extends StatefulWidget {
  const AddCattleScreen({super.key});

  @override
  State<AddCattleScreen> createState() => _AddCattleScreenState();
}

class _AddCattleScreenState extends State<AddCattleScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  // Form values
  String _selectedBreed = 'Holstein';
  String _selectedGender = 'Female';
  String _selectedStatus = 'Active';
  DateTime _selectedDob = DateTime.now().subtract(const Duration(days: 365));
  DateTime _selectedCalvingDate = DateTime.now().add(const Duration(days: 280));

  // Options
  final List<String> _breeds = [
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

  final List<String> _genders = ['Female', 'Male'];
  final List<String> _statuses = ['Active', 'Pregnant', 'Sick', 'Dry', 'Sold'];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _tagController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Scaffold(
      extendBody: true,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colorScheme.primary.withAlpha(100),
              colorScheme.surface,
              colorScheme.secondary.withAlpha(90),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Add New Cattle',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: SafeArea(
                minimum: const EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        context,
                        'Basic Information',
                        Icons.info,
                      ),
                      const SizedBox(height: 16),
                      _buildBasicInfoSection(context),

                      const SizedBox(height: 32),
                      _buildSectionHeader(
                        context,
                        'Physical Details',
                        Icons.pets,
                      ),
                      const SizedBox(height: 16),
                      _buildPhysicalDetailsSection(context),

                      const SizedBox(height: 32),
                      _buildSectionHeader(
                        context,
                        'Important Dates',
                        Icons.calendar_today,
                      ),
                      const SizedBox(height: 16),
                      _buildDatesSection(context),

                      const SizedBox(height: 32),
                      _buildSectionHeader(
                        context,
                        'Additional Information',
                        Icons.note,
                      ),
                      const SizedBox(height: 16),
                      _buildAdditionalInfoSection(context),

                      const SizedBox(height: 40),
                      _buildActionButtons(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: context.colorScheme.onPrimaryContainer,
            size: 20,
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

  Widget _buildBasicInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withAlpha(200),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
      ),
      child: Column(
        children: [
          CustomTextField(
            labelText: 'Cattle Name *',
            controller: _nameController,
            hintText: 'Enter cattle name (e.g., Ganga, Kamdhenu)',
            suffixIcon: const Icon(Icons.pets),
            validator: (value) {
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
            validator: (value) {
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
  }

  Widget _buildPhysicalDetailsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withAlpha(200),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
      ),
      child: Column(
        children: [
          _buildDropdownField(
            context,
            'Breed *',
            _selectedBreed,
            _breeds,
            Icons.category,
            (value) => setState(() => _selectedBreed = value!),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  context,
                  'Gender *',
                  _selectedGender,
                  _genders,
                  _selectedGender == 'Female' ? Icons.female : Icons.male,
                  (value) => setState(() => _selectedGender = value!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  context,
                  'Status *',
                  _selectedStatus,
                  _statuses,
                  Icons.health_and_safety,
                  (value) => setState(() => _selectedStatus = value!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withAlpha(200),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
      ),
      child: Column(
        children: [
          _buildDateField(
            context,
            'Date of Birth *',
            _selectedDob,
            Icons.cake,
            (date) => setState(() => _selectedDob = date),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          ),
          const SizedBox(height: 16),
          if (_selectedGender == 'Female') ...[
            _buildDateField(
              context,
              'Expected Calving Date',
              _selectedCalvingDate,
              Icons.baby_changing_station,
              (date) => setState(() => _selectedCalvingDate = date),
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
  }

  Widget _buildAdditionalInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withAlpha(200),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
      ),
      child: CustomTextField(
        labelText: 'Notes (Optional)',
        controller: _notesController,
        hintText: 'Add any additional notes about this cattle...',
        suffixIcon: const Icon(Icons.note_add),
        maxLines: 4,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    String label,
    String value,
    List<String> options,
    IconData icon,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(100),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              prefixIcon: Icon(icon, color: context.colorScheme.primary),
            ),
            items: options
                .map(
                  (option) =>
                      DropdownMenuItem(value: option, child: Text(option)),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime selectedDate,
    IconData icon,
    void Function(DateTime) onDateSelected, {
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(100),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Icon(icon, color: context.colorScheme.primary),
            title: Text(
              _formatDate(selectedDate),
              style: context.textTheme.bodyMedium,
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
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
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveCattle,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: context.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.colorScheme.onPrimary,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save),
                      const SizedBox(width: 8),
                      Text(
                        'Save Cattle',
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
        SizedBox(
          width: double.infinity,
          height: 56,
          child: TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: context.colorScheme.outline.withAlpha(100),
                ),
              ),
            ),
            child: Text(
              'Cancel',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _saveCattle() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create cattle object with all required fields
      final cattleData = {
        'userId': 'current_user_id', // Get from auth service
        'name': _nameController.text.trim(),
        'tagId': _tagController.text.trim(),

        'breed': _selectedBreed,
        'gender': _selectedGender,
        'dob': _selectedDob.toIso8601String(),
        'calvingDate': _selectedCalvingDate.toIso8601String(),
        'status': _selectedStatus,
        'notes': _notesController.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // TODO: Send to your API/database
      print('Cattle data to save: $cattleData');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_nameController.text} added successfully!'),
            backgroundColor: context.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, cattleData); // Return data to previous screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding cattle: $e'),
            backgroundColor: context.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildImagePickerSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cattle Photo (Optional)',
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(100),
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12),
            color: context.colorScheme.surfaceVariant.withAlpha(50),
          ),
          child: _selectedImage != null
              ? Stack(
                  children: [
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
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
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
