import 'package:cached_network_image/cached_network_image.dart';
import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
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

  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    context.read<CattleCubit>().getAllCattle();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScaffoldContainer(
      child: RefreshIndicator(
        onRefresh: () => context.read<CattleCubit>().getAllCattle(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              title: BlocBuilder<CattleCubit, CattleState>(
                builder: (BuildContext context, CattleState state) {
                  final int cattleCount = state.cattle.length;
                  return HeaderForAdd(
                    padding: EdgeInsets.zero,
                    title: 'My Cattles',
                    subTitle:
                        '$cattleCount Cattle${cattleCount != 1 ? 's' : ''}',
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
                  onChanged: (String v) {},
                  decoration: InputDecoration(
                    hintText: context.strings.milkScreenSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {},
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
                    child: Center(child: Text(state.msg)),
                  );
                }

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
                            'No cattle found',
                            style: context.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurface.withAlpha(
                                150,
                              ),
                            ),
                          ),
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
                    itemCount: cattleList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _buildCattleCard(context, cattleList[index]),
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
