import 'package:cached_network_image/cached_network_image.dart';
import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/utils/debouncer.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/header_for_add.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
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
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(const Duration(milliseconds: 500));
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<CattleCubit>().getCattle();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CattleCubit>().loadMore();
    }
  }

  void _performSearch() {
    final String? search = _searchQuery.isNotEmpty ? _searchQuery : null;
    context.read<CattleCubit>().applySearch(search);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');

    context.read<CattleCubit>().applySearch(null);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: RefreshIndicator(
      onRefresh: () => context.read<CattleCubit>().refreshCattle(),
      child: CustomScaffoldContainer(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              title: BlocBuilder<CattleCubit, CattleState>(
                builder: (BuildContext context, CattleState state) {
                  final int cattleCount = state.cattle.length;
                  final bool isSearching = state.search?.isNotEmpty ?? false;

                  return HeaderForAdd(
                    padding: EdgeInsets.zero,
                    title: isSearching
                        ? context.strings.searchResults
                        : context.strings.myCattles,
                    subTitle: isSearching
                        ? '$cattleCount ${context.strings.found}'
                        : '$cattleCount ${cattleCount != 1 ? context.strings.cattlePlural : context.strings.cattleSingular}',
                    onTap: () => context.push(AppRoutes.addCattle),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (String value) {
                    setState(() => _searchQuery = value);
                    _debouncer.run(_performSearch);
                  },
                  decoration: InputDecoration(
                    hintText: context.strings.milkScreenSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
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
              ),
            ),

            BlocBuilder<CattleCubit, CattleState>(
              builder: (BuildContext context, CattleState state) {
                final List<Cattle> cattleList = state.cattle;

                if (state is CattleLoadingState && state.cattle.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is CattleLoadedFailure && state.cattle.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: context.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.strings.failedToLoadCattle,
                            style: context.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.msg,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurface.withAlpha(
                                150,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<CattleCubit>().refreshCattle(),
                            child: Text(context.strings.retry),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Show empty state
                if (cattleList.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.pets_outlined,
                            size: 64,
                            color: context.colorScheme.onSurface.withAlpha(100),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            (state.search?.isNotEmpty ?? false)
                                ? '${context.strings.noCattleFound} "${state.search}"'
                                : context.strings.noCattleFound,
                            style: context.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            (state.search?.isNotEmpty ?? false)
                                ? context.strings.tryDifferentSearch
                                : context.strings.addFirstCattle,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurface.withAlpha(
                                150,
                              ),
                            ),
                          ),
                          if (state.search?.isNotEmpty ?? false) ...[
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: _clearSearch,
                              child: Text(context.strings.clearSearch),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.only(
                    top: 8,
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).size.height * 0.15,
                  ),
                  sliver: SliverList.builder(
                    itemCount: cattleList.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= cattleList.length) {
                        // Show loading indicator at the bottom when loading more
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: state is CattleLoadingState
                                ? const CircularProgressIndicator()
                                : const SizedBox.shrink(),
                          ),
                        );
                      }
                      return _buildCattleCard(context, cattleList[index]);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildCattleCard(BuildContext context, Cattle cattle) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
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
                            _getLocalizedStatus(cattle.status, context),
                            style: context.textTheme.labelSmall?.copyWith(
                              color: _getStatusColor(context, cattle.status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${context.strings.tag}: ${cattle.tagId} • ${cattle.breed}',
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
                  context.strings.age,
                  calculateCattleAge(cattle.dob),
                  Icons.calendar_today,
                ),
              ),
              if (cattle.gender == 'Female')
                Expanded(
                  child: _buildInfoItem(
                    context,
                    context.strings.thisMonth,
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
      return '$months ${context.strings.months}';
    }
    if (months == 0) {
      return '$years ${context.strings.years}';
    }
    return '$years ${context.strings.years} $months ${context.strings.months}';
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

  String _getLocalizedStatus(String status, BuildContext context) {
    switch (status) {
      case 'Active':
        return context.strings.active;
      case 'Sick':
        return context.strings.sick;
      case 'Sold':
        return context.strings.sold;
      case 'Dead':
        return context.strings.dead;
      default:
        return status;
    }
  }
}
