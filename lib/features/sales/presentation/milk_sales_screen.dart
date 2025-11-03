import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/widget/header_for_add.dart';
import 'package:digital_dairy/features/sales/cubit/sales_cubit.dart';
import 'package:digital_dairy/features/sales/model/buyer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MilkSalesScreen extends StatefulWidget {
  const MilkSalesScreen({super.key});

  @override
  State<MilkSalesScreen> createState() => _MilkSalesScreenState();
}

class _MilkSalesScreenState extends State<MilkSalesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<SalesCubit>().getBuyers();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Buyer> _filterBuyers(List<Buyer> buyers) {
    if (_searchQuery.isEmpty) {
      return buyers;
    }

    return buyers.where((Buyer buyer) {
      final String query = _searchQuery.toLowerCase();
      return buyer.name.toLowerCase().contains(query) ||
          buyer.contact.toLowerCase().contains(query) ||
          buyer.address.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        _appbar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search buyers...',
              leading: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
              trailing: _searchQuery.isNotEmpty
                  ? <Widget>[
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      ),
                    ]
                  : null,
              onChanged: (String value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              elevation: const WidgetStatePropertyAll<double>(0),
              backgroundColor: WidgetStatePropertyAll<Color>(
                colorScheme.surfaceContainerHighest,
              ),
              shape: WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
        BlocBuilder<SalesCubit, SalesState>(
          builder: (BuildContext context, SalesState state) {
            final List<Buyer> buyerData = state.buyers;
            final List<Buyer> filteredBuyers = _filterBuyers(buyerData);

            if (buyerData.isEmpty) {
              return SliverFillRemaining(child: _buildEmptyState(context));
            }

            if (filteredBuyers.isEmpty) {
              return SliverFillRemaining(child: _buildNoSearchResults(context));
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: filteredBuyers.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  final Buyer buyer = filteredBuyers[index];
                  return _BuyerCard(
                    key: ValueKey<String>(buyer.id!),
                    buyer: buyer,
                  );
                },
              ),
            );
          },
        ),
        SliverPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withAlpha(102),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline_rounded,
                size: 80,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Buyers Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start building your customer base by\nadding your first buyer',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: () => context.pushNamed(AppRoutes.addBuyer),
              icon: const Icon(Icons.person_add_alt_1_outlined),
              label: const Text('Add Your First Buyer'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSearchResults(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: colorScheme.outline.withAlpha(128),
            ),
            const SizedBox(height: 24),
            Text(
              'No Results Found',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _appbar(BuildContext context) => SliverAppBar(
    backgroundColor: Colors.transparent,
    floating: true,
    snap: true,
    title: HeaderForAdd(
      padding: EdgeInsets.zero,
      title: 'Add Buyers',
      subTitle: '',
      onTap: () async {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject()! as RenderBox;

        final String? value = await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(
            overlay.size.width - 100,
            80,
            20,
            overlay.size.height - 200,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          items: <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'buyer',
              child: Row(
                children: <Widget>[
                  Icon(Icons.person_add_alt_1_outlined),
                  SizedBox(width: 8),
                  Text('Add Buyer'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'sales',
              child: Row(
                children: <Widget>[
                  Icon(Icons.local_mall_outlined),
                  SizedBox(width: 8),
                  Text('Add Sale'),
                ],
              ),
            ),
          ],
        );

        if (value == 'buyer') {
          if (!context.mounted) {
            return;
          }
          await context.pushNamed(AppRoutes.addBuyer);
        } else if (value == 'sales') {
          if (!context.mounted) {
            return;
          }
          await context.pushNamed(AppRoutes.addSales);
        }
      },
    ),
  );
}

class _BuyerCard extends StatelessWidget {
  const _BuyerCard({required this.buyer, super.key});

  final Buyer buyer;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surface.withAlpha(180),
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push(
            AppRoutes.buyerSales,
            extra: <String, String?>{
              'buyerId': buyer.id,
              'buyerName': buyer.name,
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // NAME ROW WITH AVATAR
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      buyer.name.isNotEmpty ? buyer.name[0].toUpperCase() : '?',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
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
                              buyer.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.more_vert,
                              color: colorScheme.onSurface.withAlpha(150),
                              size: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.edit_outlined, size: 18),
                                        SizedBox(width: 12),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.delete_outline, size: 18),
                                        SizedBox(width: 12),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ],
                            onSelected: (String value) {
                              // Handle menu actions
                            },
                          ),
                        ],
                      ),
                      if (buyer.contact.isNotEmpty)
                        Text(
                          'Phone: ${buyer.contact}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withAlpha(150),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (buyer.address.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              _buildInfoItem(
                context,
                'Address',
                buyer.address,
                Icons.location_on_outlined,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'Added',
                    _formatDate(buyer.createdAt),
                    Icons.calendar_today_outlined,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: () {
                    context.push(
                      AppRoutes.addSales,
                      extra: <String, String?>{
                        'id': buyer.id,
                        'name': buyer.name,
                      },
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text('Add Sale'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ],
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withAlpha(120),
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
