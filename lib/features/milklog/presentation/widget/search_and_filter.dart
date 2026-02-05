import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

///
class SearchAndFilters extends StatelessWidget {
  ///
  const SearchAndFilters({
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onSearchCleared,
    required this.sortBy,
    required this.onSortTapped,
    super.key,
  });

  ///
  final TextEditingController searchController;

  ///
  final String searchQuery;

  ///
  final ValueChanged<String> onSearchChanged;

  ///
  final VoidCallback onSearchCleared;

  ///
  final String sortBy;

  ///
  final VoidCallback onSortTapped;

  ///

  String _getSortDisplayText(BuildContext context) {
    switch (sortBy) {
      case 'Date':
        return context.strings.sortDate;
      case 'Quantity':
        return context.strings.sortQuantity;
      case 'Morning Shift':
        return context.strings.sortMorningShift;
      case 'Evening Shift':
        return context.strings.sortEveningShift;
      case 'All Shifts':
        return context.strings.sortAllShifts;
      default:
        return sortBy;
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: context.strings.milkScreenSearchHint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onSearchCleared,
                )
              : null,
          filled: true,
          fillColor: context.colorScheme.surfaceContainerHighest,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: context.colorScheme.outline.withAlpha(100),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: context.colorScheme.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      // Sort/Filter Options
      GestureDetector(
        onTap: onSortTapped,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(100),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                context.strings.milkScreenSortFilterOptions,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    _getSortDisplayText(context),
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.sort,
                    size: 20,
                    color: context.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
