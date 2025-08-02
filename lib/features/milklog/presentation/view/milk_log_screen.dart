import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/widget/header_for_add.dart';
import 'package:digital_dairy/features/milklog/model/milk_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
class MilkScreen extends StatefulWidget {
  ///
  const MilkScreen({super.key});

  @override
  State<MilkScreen> createState() => _MilkScreenState();
}

class _MilkScreenState extends State<MilkScreen> {
  // Dummy data for demonstration
  final List<MilkModel> _dummyMilkEntries = [
    MilkModel(
      id: '1',
      cattleId: 'COW001',
      date: DateTime.now(),
      shift: 'Morning',
      quantityInLiter: 12.5,
      notes: 'Good quality milk, cow seems healthy',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    MilkModel(
      id: '2',
      cattleId: 'COW001',
      date: DateTime.now(),
      shift: 'Evening',
      quantityInLiter: 10.8,
      notes: 'Normal production',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    MilkModel(
      id: '3',
      cattleId: 'COW002',
      date: DateTime.now().subtract(const Duration(days: 1)),
      shift: 'Morning',
      quantityInLiter: 15.2,
      notes: 'Excellent production today',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
    ),
    MilkModel(
      id: '4',
      cattleId: 'COW002',
      date: DateTime.now().subtract(const Duration(days: 1)),
      shift: 'Evening',
      quantityInLiter: 13.7,
      notes: '',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
    ),
    MilkModel(
      id: '5',
      cattleId: 'COW003',
      date: DateTime.now().subtract(const Duration(days: 2)),
      shift: 'Morning',
      quantityInLiter: 9.3,
      notes: 'Slightly lower than usual, monitoring',
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
    ),
    MilkModel(
      id: '6',
      cattleId: 'COW003',
      date: DateTime.now().subtract(const Duration(days: 2)),
      shift: 'Evening',
      quantityInLiter: 11.1,
      notes: 'Back to normal levels',
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
    ),
  ];

  String _searchQuery = '';
  String _sortBy = 'Date';

  final List<String> _sortOptions = [
    'Date',
    'Quantity',
    'Cattle Name',
    'Morning Shift',
    'Evening Shift',
    'All Shifts',
  ];

  List<MilkModel> get _filteredMilkEntries {
    final List<MilkModel> milkEntries = _dummyMilkEntries;

    final List<MilkModel> filtered = milkEntries.where((MilkModel entry) {
      final bool matchesSearch =
          entry.cattleId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          entry.notes.toLowerCase().contains(_searchQuery.toLowerCase());

      // Apply shift filter based on sort selection
      if (_sortBy == 'Morning Shift') {
        return matchesSearch && entry.shift == 'Morning';
      } else if (_sortBy == 'Evening Shift') {
        return matchesSearch && entry.shift == 'Evening';
      }

      return matchesSearch;
    }).toList();

    switch (_sortBy) {
      case 'Quantity':
        filtered.sort((a, b) => b.quantityInLiter.compareTo(a.quantityInLiter));
        break;
      case 'Cattle Name':
        filtered.sort((a, b) => a.cattleId.compareTo(b.cattleId));
        break;
      case 'Morning Shift':
      case 'Evening Shift':
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      default:
        filtered.sort((a, b) => b.date.compareTo(a.date));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBody: true,
    body: Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            context.colorScheme.primary.withAlpha(80),
            context.colorScheme.surface,
            context.colorScheme.secondary.withAlpha(60),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            // Custom App Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface.withAlpha(200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Milk Records',
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface.withAlpha(200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // TODO: Implement add milk entry
                      },
                      icon: Icon(Icons.add, color: context.colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Column(
                children: <Widget>[
                  _buildSearchAndFilters(context),
                  _buildSummaryRow(context),
                  Expanded(child: _buildMilkEntriesList(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildSearchAndFilters(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: <Widget>[
        // Search bar
        TextField(
          onChanged: (String value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Search by cattle ID or notes...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.colorScheme.outline),
            ),
            filled: true,
            fillColor: context.colorScheme.surface.withAlpha(200),
          ),
        ),
        const SizedBox(height: 12),
        // Sort button
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showSortOptions(context),
                icon: const Icon(Icons.sort, size: 18),
                label: Text(_getSortDisplayText()),
                style: OutlinedButton.styleFrom(
                  backgroundColor: context.colorScheme.surface.withAlpha(150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    ),
  );

  Widget _buildSummaryRow(BuildContext context) {
    final double totalMilk = _filteredMilkEntries.fold(
      0.0,
      (sum, entry) => sum + entry.quantityInLiter,
    );

    final double morningMilk = _filteredMilkEntries
        .where((entry) => entry.shift == 'Morning')
        .fold(0.0, (sum, entry) => sum + entry.quantityInLiter);

    final double eveningMilk = _filteredMilkEntries
        .where((entry) => entry.shift == 'Evening')
        .fold(0.0, (sum, entry) => sum + entry.quantityInLiter);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withAlpha(150),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildSummaryItem(
            context,
            'Total',
            '${totalMilk.toStringAsFixed(1)}L',
            Icons.water_drop,
            context.colorScheme.primary,
          ),
          _buildSummaryItem(
            context,
            'Morning',
            '${morningMilk.toStringAsFixed(1)}L',
            Icons.wb_sunny,
            Colors.orange,
          ),
          _buildSummaryItem(
            context,
            'Evening',
            '${eveningMilk.toStringAsFixed(1)}L',
            Icons.nights_stay,
            Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Icon(icon, color: color, size: 20),
      const SizedBox(height: 4),
      Text(
        title,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colorScheme.onSurface.withAlpha(150),
        ),
      ),
      Text(
        value,
        style: context.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );

  Widget _buildMilkEntriesList(BuildContext context) {
    if (_filteredMilkEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.water_drop_outlined,
              size: 64,
              color: context.colorScheme.onSurface.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text('No milk entries found', style: context.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredMilkEntries.length,
      itemBuilder: (BuildContext context, int index) =>
          _buildMilkEntryCard(context, _filteredMilkEntries[index]),
    );
  }

  Widget _buildMilkEntryCard(
    BuildContext context,
    MilkModel milkEntry,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.colorScheme.surface.withAlpha(180),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _showMilkEntryDetail(context, milkEntry),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header row
          Row(
            children: <Widget>[
              Text(
                milkEntry.cattleId,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getShiftColor(milkEntry.shift, context).withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      milkEntry.shift == 'Morning'
                          ? Icons.wb_sunny
                          : Icons.nights_stay,
                      size: 14,
                      color: _getShiftColor(milkEntry.shift, context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      milkEntry.shift,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: _getShiftColor(milkEntry.shift, context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Details row
          Row(
            children: <Widget>[
              Icon(
                Icons.water_drop,
                size: 16,
                color: context.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '${milkEntry.quantityInLiter.toStringAsFixed(1)}L',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.calendar_today,
                size: 16,
                color: context.colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDate(milkEntry.date),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ],
          ),
          if (milkEntry.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              milkEntry.notes,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withAlpha(120),
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ),
  );

  String _getSortDisplayText() {
    switch (_sortBy) {
      case 'Morning Shift':
        return 'Morning Only';
      case 'Evening Shift':
        return 'Evening Only';
      case 'All Shifts':
        return 'All Entries';
      default:
        return 'Sort: $_sortBy';
    }
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort & Filter Options',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._sortOptions.map(
              (option) => ListTile(
                leading: Icon(
                  _getOptionIcon(option),
                  color: _sortBy == option
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurface.withAlpha(150),
                ),
                title: Text(option),
                trailing: _sortBy == option
                    ? Icon(Icons.check, color: context.colorScheme.primary)
                    : null,
                onTap: () {
                  setState(() => _sortBy = option);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getOptionIcon(String option) {
    switch (option) {
      case 'Date':
        return Icons.calendar_today;
      case 'Quantity':
        return Icons.water_drop;
      case 'Cattle Name':
        return Icons.pets;
      case 'Morning Shift':
        return Icons.wb_sunny;
      case 'Evening Shift':
        return Icons.nights_stay;
      case 'All Shifts':
        return Icons.all_inclusive;
      default:
        return Icons.sort;
    }
  }

  Color _getShiftColor(String shift, BuildContext context) {
    switch (shift) {
      case 'Morning':
        return Colors.orange;
      case 'Evening':
        return Colors.indigo;
      default:
        return context.colorScheme.primary;
    }
  }

  String _formatDate(DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateTime entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (entryDate.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else {
      const List<String> months = [
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
      return '${date.day} ${months[date.month - 1]}';
    }
  }

  void _showMilkEntryDetail(BuildContext context, MilkModel milkEntry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colorScheme.surface,
        title: const Text('Milk Entry Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cattle: ${milkEntry.cattleId}'),
            Text('Date: ${_formatFullDate(milkEntry.date)}'),
            Text('Shift: ${milkEntry.shift}'),
            Text('Quantity: ${milkEntry.quantityInLiter.toStringAsFixed(2)}L'),
            if (milkEntry.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Notes: ${milkEntry.notes}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
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
