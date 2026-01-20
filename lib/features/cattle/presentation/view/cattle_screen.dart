import 'package:cached_network_image/cached_network_image.dart';
import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/widget/header_for_add.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:digital_dairy/features/cattle/presentation/widget/style_filte_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

///
class CattleScreen extends StatefulWidget {
  ///
  const CattleScreen({super.key});

  @override
  State<CattleScreen> createState() => _CattleScreenState();
}

class _CattleScreenState extends State<CattleScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CattleCubit>().getAllCattle();
  }

  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedBreed = 'All';
  String _selectedGender = 'All';
  String _sortBy = 'Name';

  final List<String> _statuses = <String>[
    'All',
    'Active',
    'Sick',
    'Sold',
    'Dead',
  ];
  final List<String> _breeds = <String>[
    'All',
    'Holstein',
    'Jersey',
    'Gir',
    'Sahiwal',
  ];
  final List<String> _genders = <String>['All', 'Female', 'Male'];
  final List<String> _sortOptions = <String>[
    'Name',
    'Age',
    'Milk Production',
    'Status',
  ];
  List<Cattle> get _filteredCattle {
    final List<Cattle> cattle = context.watch<CattleCubit>().state.cattle;

    final List<Cattle> filtered = cattle.where((Cattle cattle) {
      final bool matchesSearch =
          cattle.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          cattle.tagId.toLowerCase().contains(_searchQuery.toLowerCase());
      final bool matchesStatus =
          _selectedStatus == 'All' || cattle.status == _selectedStatus;
      final bool matchesBreed =
          _selectedBreed == 'All' || cattle.breed == _selectedBreed;
      final bool matchesGender =
          _selectedGender == 'All' || cattle.gender == _selectedGender;

      return matchesSearch && matchesStatus && matchesBreed && matchesGender;
    }).toList();

    // switch (_sortBy) {
    //   case 'Age':
    //     filtered.sort((a, b) => a.ageInMonths.compareTo(b.ageInMonths));
    //     break;
    //   case 'Milk Production':
    //     filtered.sort((a, b) => b.monthlyMilk.compareTo(a.monthlyMilk));
    //     break;
    //   case 'Status':
    //     filtered.sort((a, b) => a.status.compareTo(b.status));
    //     break;
    //   default:
    //     filtered.sort((a, b) => a.name.compareTo(b.name));
    // }

    return filtered;
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      children: <Widget>[
        HeaderForAdd(
          title: 'My Cattles',
          subTitle: '${3} Cattle',
          onTap: () => context.push(AppRoutes.addCattle),
        ),

        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              StyledFilterChip(
                label: 'Status',
                selected: _selectedStatus,
                options: _statuses,
                onSelected: (String value) =>
                    setState(() => _selectedStatus = value),
              ),
              const SizedBox(width: 8),
              StyledFilterChip(
                label: 'Breed',
                selected: _selectedBreed,
                options: _breeds,
                onSelected: (String value) =>
                    setState(() => _selectedBreed = value),
              ),
              const SizedBox(width: 8),
              StyledFilterChip(
                label: 'Gender',
                selected: _selectedGender,
                options: _genders,
                onSelected: (String value) =>
                    setState(() => _selectedGender = value),
              ),
              const SizedBox(width: 8),
              StyledFilterChip(
                label: 'Sort',
                selected: _sortBy,
                options: _sortOptions,
                onSelected: (String value) => setState(() => _sortBy = value),
              ),
            ],
          ),
        ),
        Expanded(child: _buildCattleList(context)),
      ],
    ),
  );

  Widget _buildCattleList(BuildContext context) {
    final CattleState state = context.watch<CattleCubit>().state;

    if (state is CattleLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CattleLoadedFailure) {
      return Center(child: Text(state.msg));
    }

    if (_filteredCattle.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('No cattle found', style: context.textTheme.titleMedium),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredCattle.length,
      itemBuilder: (BuildContext context, int index) =>
          _buildCattleCard(context, _filteredCattle[index]),
    );
  }

  Widget _buildCattleCard(BuildContext context, Cattle cattle) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(15),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push(AppRoutes.cattleDetail, extra: cattle),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // NAME ROW WITH IMAGE
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      (cattle.imageUrl?.isNotEmpty ?? false)
                          ? cattle.imageUrl!
                          : 'https://thumbs.dreamstime.com/b/comic-cow-model-taken-closeup-effect-40822303.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            cattle.name,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
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
                              color: _getStatusColor(context, cattle.status),
                            ),
                          ),
                          child: Text(
                            cattle.status,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: _getStatusColor(context, cattle.status),
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
          // Age and this month
          Row(
            children: <Widget>[
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Age',
                  calculateCattleAge(cattle.dob),
                  Icons.calendar_today,
                ),
              ),
              if (cattle.gender == 'Female')
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'This Month',
                    '${cattle.thisMonthL}L',
                    Icons.water_drop,
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );

  String calculateCattleAge(DateTime? dob) {
    if (dob == null) {
      return '-';
    }

    final DateTime now = DateTime.now();
    int years = now.year - dob.year;
    int months = now.month - dob.month;

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    if (years == 0) {
      return '$months mo';
    }
    if (months == 0) {
      return '$years y';
    }
    return '$years y $months mo';
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) => Column(
    children: <Widget>[
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
}
