import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/widget/header_for_add.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Dummy data models
class Cattle {
  final String id;
  final String name;
  final String tagId;
  final String breed;
  final String gender;
  final DateTime dob;
  final DateTime? lastCalvingDate;
  final String status;
  final double monthlyMilk;
  final double yearlyMilk;
  final DateTime? nextVaccinationDue;
  final DateTime? lastTreatmentDate;
  final String healthNotes;
  final double totalExpenses;
  final String notes;
  final List<MilkEntry> recentMilkEntries;

  Cattle({
    required this.id,
    required this.name,
    required this.tagId,
    required this.breed,
    required this.gender,
    required this.dob,
    this.lastCalvingDate,
    required this.status,
    required this.monthlyMilk,
    required this.yearlyMilk,
    this.nextVaccinationDue,
    this.lastTreatmentDate,
    this.healthNotes = '',
    this.totalExpenses = 0.0,
    this.notes = '',
    this.recentMilkEntries = const [],
  });

  int get ageInMonths {
    final now = DateTime.now();
    return ((now.year - dob.year) * 12 + now.month - dob.month);
  }

  String get ageString {
    final months = ageInMonths;
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    if (years > 0) {
      return '$years y ${remainingMonths}m';
    }
    return '${months}m';
  }
}

class MilkEntry {
  final DateTime date;
  final double morning;
  final double evening;

  MilkEntry({required this.date, required this.morning, required this.evening});

  double get total => morning + evening;
}

class CattleScreen extends StatefulWidget {
  const CattleScreen({super.key});

  @override
  State<CattleScreen> createState() => _CattleScreenState();
}

class _CattleScreenState extends State<CattleScreen> {
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedBreed = 'All';
  String _selectedGender = 'All';
  String _sortBy = 'Name';

  final List<String> _statuses = ['All', 'Active', 'Sick', 'Sold', 'Dead'];
  final List<String> _breeds = ['All', 'Holstein', 'Jersey', 'Gir', 'Sahiwal'];
  final List<String> _genders = ['All', 'Female', 'Male'];
  final List<String> _sortOptions = [
    'Name',
    'Age',
    'Milk Production',
    'Status',
  ];

  // Dummy data
  final List<Cattle> _allCattle = [
    Cattle(
      id: '1',
      name: 'Ganga',
      tagId: 'C001',
      breed: 'Holstein',
      gender: 'Female',
      dob: DateTime(2020, 3, 15),
      lastCalvingDate: DateTime(2024, 1, 10),
      status: 'Active',
      monthlyMilk: 450.5,
      yearlyMilk: 5406.0,
      nextVaccinationDue: DateTime(2024, 12, 15),
      lastTreatmentDate: DateTime(2024, 6, 20),
      healthNotes: 'Regular checkup needed',
      totalExpenses: 15000.0,
      notes: 'High milk producer',
      recentMilkEntries: [
        MilkEntry(date: DateTime(2024, 7, 25), morning: 12.5, evening: 10.0),
        MilkEntry(date: DateTime(2024, 7, 24), morning: 13.0, evening: 9.5),
        MilkEntry(date: DateTime(2024, 7, 23), morning: 12.0, evening: 10.5),
      ],
    ),
    Cattle(
      id: '2',
      name: 'Kamdhenu',
      tagId: 'C002',
      breed: 'Jersey',
      gender: 'Female',
      dob: DateTime(2019, 8, 22),
      lastCalvingDate: DateTime(2023, 11, 5),
      status: 'Sick',
      monthlyMilk: 320.0,
      yearlyMilk: 3840.0,
      nextVaccinationDue: DateTime(2024, 8, 10),
      lastTreatmentDate: DateTime(2024, 7, 15),
      healthNotes: 'Mastitis treatment ongoing',
      totalExpenses: 22000.0,
      notes: 'Under medical care',
      recentMilkEntries: [
        MilkEntry(date: DateTime(2024, 7, 25), morning: 8.0, evening: 7.0),
        MilkEntry(date: DateTime(2024, 7, 24), morning: 8.5, evening: 6.5),
      ],
    ),
    Cattle(
      id: '3',
      name: 'Nandi',
      tagId: 'C003',
      breed: 'Gir',
      gender: 'Male',
      dob: DateTime(2021, 12, 10),
      status: 'Active',
      monthlyMilk: 0.0,
      yearlyMilk: 0.0,
      totalExpenses: 8000.0,
      notes: 'Breeding bull',
    ),
  ];

  List<Cattle> get _filteredCattle {
    List<Cattle> filtered = _allCattle.where((cattle) {
      final matchesSearch =
          cattle.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          cattle.tagId.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _selectedStatus == 'All' || cattle.status == _selectedStatus;
      final matchesBreed =
          _selectedBreed == 'All' || cattle.breed == _selectedBreed;
      final matchesGender =
          _selectedGender == 'All' || cattle.gender == _selectedGender;

      return matchesSearch && matchesStatus && matchesBreed && matchesGender;
    }).toList();

    // Sort
    switch (_sortBy) {
      case 'Age':
        filtered.sort((a, b) => a.ageInMonths.compareTo(b.ageInMonths));
        break;
      case 'Milk Production':
        filtered.sort((a, b) => b.monthlyMilk.compareTo(a.monthlyMilk));
        break;
      case 'Status':
        filtered.sort((a, b) => a.status.compareTo(b.status));
        break;
      default:
        filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          HeaderForAdd(
            title: 'My Cattles',
            subTitle: '${_filteredCattle.length} Cattle',
            onTap: () => context.push(AppRoutes.addCattle),
          ),
          _buildSearchAndFilters(context),
          Expanded(child: _buildCattleList(context)),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Search bar
          TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search by name or tag...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.colorScheme.outline),
              ),
              filled: true,
              fillColor: context.colorScheme.surface,
            ),
          ),
          const SizedBox(height: 12),
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Status', _selectedStatus, _statuses, (value) {
                  setState(() => _selectedStatus = value);
                }),
                const SizedBox(width: 8),
                _buildFilterChip('Breed', _selectedBreed, _breeds, (value) {
                  setState(() => _selectedBreed = value);
                }),
                const SizedBox(width: 8),
                _buildFilterChip('Gender', _selectedGender, _genders, (value) {
                  setState(() => _selectedGender = value);
                }),
                const SizedBox(width: 8),
                _buildFilterChip('Sort', _sortBy, _sortOptions, (value) {
                  setState(() => _sortBy = value);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String selected,
    List<String> options,
    Function(String) onSelected,
  ) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) => options
          .map((option) => PopupMenuItem(value: option, child: Text(option)))
          .toList(),
      child: Chip(
        label: Text('$label: $selected'),
        backgroundColor: context.colorScheme.secondaryContainer,
        side: BorderSide(color: context.colorScheme.outline),
      ),
    );
  }

  Widget _buildCattleList(BuildContext context) {
    if (_filteredCattle.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 64,
              color: context.colorScheme.onSurface.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text(
              'No cattle found',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredCattle.length,
      itemBuilder: (context, index) =>
          _buildCattleCard(context, _filteredCattle[index]),
    );
  }

  Widget _buildCattleCard(BuildContext context, Cattle cattle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showCattleDetail(context, cattle),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      cattle.gender == 'Male' ? Icons.male : Icons.female,
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              cattle.name,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  context,
                                  cattle.status,
                                ).withAlpha(50),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getStatusColor(
                                    context,
                                    cattle.status,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                cattle.status,
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: _getStatusColor(
                                    context,
                                    cattle.status,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Tag: ${cattle.tagId} • ${cattle.breed}',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface.withAlpha(150),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      'Age',
                      cattle.ageString,
                      Icons.calendar_today,
                    ),
                  ),
                  if (cattle.lastCalvingDate != null)
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        'Last Calving',
                        _formatDate(cattle.lastCalvingDate!),
                        Icons.baby_changing_station,
                      ),
                    ),
                  if (cattle.gender == 'Female')
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        'This Month',
                        '${cattle.monthlyMilk.toStringAsFixed(1)}L',
                        Icons.water_drop,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: context.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(120),
          ),
        ),
        Text(
          value,
          style: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Sick':
        return Colors.orange;
      case 'Sold':
        return Colors.blue;
      case 'Dead':
        return Colors.red;
      default:
        return context.colorScheme.onSurface;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    if (difference < 30) {
      return '${difference}d ago';
    } else if (difference < 365) {
      return '${(difference / 30).round()}m ago';
    } else {
      return '${(difference / 365).round()}y ago';
    }
  }

  void _showCattleDetail(BuildContext context, Cattle cattle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CattleDetailSheet(cattle: cattle),
    );
  }
}

class CattleDetailSheet extends StatelessWidget {
  final Cattle cattle;

  const CattleDetailSheet({super.key, required this.cattle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.colorScheme.onSurface.withAlpha(100),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    cattle.gender == 'Male' ? Icons.male : Icons.female,
                    color: context.colorScheme.onPrimaryContainer,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cattle.name,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tag: ${cattle.tagId}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(context, 'Basic Information', [
                    _buildDetailRow(context, 'Breed', cattle.breed),
                    _buildDetailRow(context, 'Gender', cattle.gender),
                    _buildDetailRow(
                      context,
                      'Date of Birth',
                      _formatFullDate(cattle.dob),
                    ),
                    _buildDetailRow(context, 'Age', cattle.ageString),
                    _buildDetailRow(context, 'Status', cattle.status),
                  ]),
                  const SizedBox(height: 24),
                  if (cattle.gender == 'Female') ...[
                    _buildSection(context, 'Production Statistics', [
                      _buildDetailRow(
                        context,
                        'Monthly Milk',
                        '${cattle.monthlyMilk.toStringAsFixed(1)} L',
                      ),
                      _buildDetailRow(
                        context,
                        'Yearly Milk',
                        '${cattle.yearlyMilk.toStringAsFixed(1)} L',
                      ),
                      _buildDetailRow(
                        context,
                        'Average Daily',
                        '${(cattle.monthlyMilk / 30).toStringAsFixed(1)} L',
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildRecentMilkEntries(context),
                    const SizedBox(height: 24),
                  ],
                  if (cattle.lastCalvingDate != null) ...[
                    _buildSection(context, 'Calving Information', [
                      _buildDetailRow(
                        context,
                        'Last Calving',
                        _formatFullDate(cattle.lastCalvingDate!),
                      ),
                      _buildDetailRow(
                        context,
                        'Days Since Calving',
                        '${DateTime.now().difference(cattle.lastCalvingDate!).inDays} days',
                      ),
                    ]),
                    const SizedBox(height: 24),
                  ],
                  _buildSection(context, 'Health Information', [
                    if (cattle.lastTreatmentDate != null)
                      _buildDetailRow(
                        context,
                        'Last Treatment',
                        _formatFullDate(cattle.lastTreatmentDate!),
                      ),
                    if (cattle.nextVaccinationDue != null)
                      _buildDetailRow(
                        context,
                        'Next Vaccination',
                        _formatFullDate(cattle.nextVaccinationDue!),
                      ),
                    if (cattle.healthNotes.isNotEmpty)
                      _buildDetailRow(
                        context,
                        'Health Notes',
                        cattle.healthNotes,
                      ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSection(context, 'Financial Information', [
                    _buildDetailRow(
                      context,
                      'Total Expenses',
                      '₹${cattle.totalExpenses.toStringAsFixed(0)}',
                    ),
                  ]),
                  if (cattle.notes.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSection(context, 'Notes', [
                      _buildDetailRow(context, 'Remarks', cattle.notes),
                    ]),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceVariant.withAlpha(80),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(50),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withAlpha(150),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMilkEntries(BuildContext context) {
    if (cattle.recentMilkEntries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Milk Entries',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceVariant.withAlpha(80),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(50),
            ),
          ),
          child: Column(
            children: cattle.recentMilkEntries
                .map(
                  (entry) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: context.colorScheme.outline.withAlpha(30),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _formatFullDate(entry.date),
                            style: context.textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          'M: ${entry.morning.toStringAsFixed(1)}L',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface.withAlpha(150),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'E: ${entry.evening.toStringAsFixed(1)}L',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface.withAlpha(150),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Total: ${entry.total.toStringAsFixed(1)}L',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  String _formatFullDate(DateTime date) {
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
}
