import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/utils/debouncer.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/core/widget/header_for_add.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:digital_dairy/features/cattle/presentation/widget/cattle_card.dart';
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
                          if (state.search?.isNotEmpty ?? false) ...<Widget>[
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
                      return CattleCard(cattle: cattleList[index]);
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
}
