import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/widget/header_for_add.dart';
import 'package:digital_dairy/features/sales/cubit/sales_cubit.dart';
import 'package:digital_dairy/features/sales/model/buyer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

///
class MilkSalesScreen extends StatefulWidget {
  ///
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

  void _showDeleteConfirmation(BuildContext context, Buyer buyer) {
    final ColorScheme colorScheme = context.colorScheme;

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        icon: Icon(Icons.delete_outline, color: colorScheme.error, size: 32),
        title: Text(context.strings.buyerDeleteTitle),
        content: Text(
          '${context.strings.buyerDeleteConfirmation} "${buyer.name}"? ${context.strings.buyerDeleteWarning}',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.strings.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<SalesCubit>().deleteBuyer(buyer.id!);
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: Text(context.strings.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => BlocListener<SalesCubit, SalesState>(
    listener: (BuildContext context, SalesState state) {
      if (state is BuyerDeleteSuccess) {
        showAppSnackbar(
          context,
          message: context.strings.buyerDeleteSuccess,
          type: SnackbarType.success,
        );
      } else if (state is BuyerDeleteFailure) {
        showAppSnackbar(
          context,
          message: state.errorMsg,
          type: SnackbarType.error,
        );
      } else if (state is BuyerUpdateSuccess) {
        showAppSnackbar(
          context,
          message: context.strings.buyerUpdatedSuccess,
          type: SnackbarType.success,
        );
      } else if (state is BuyerUpdateFailure) {
        showAppSnackbar(
          context,
          message: state.errorMsg,
          type: SnackbarType.error,
        );
      }
    },
    child: CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        _appbar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              onChanged: (String value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: context.strings.buyerSearchHint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: context.colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: context.colorScheme.outline.withAlpha(100),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: context.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
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
                    onEdit: () async {
                      await context.pushNamed(AppRoutes.addBuyer, extra: buyer);
                    },
                    onDelete: () => _showDeleteConfirmation(context, buyer),
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
    ),
  );

  Widget _buildEmptyState(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    final ColorScheme colorScheme = context.colorScheme;

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
              context.strings.buyerEmptyStateTitle,
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.strings.buyerEmptyStateSubtitle,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: () => context.pushNamed(AppRoutes.addBuyer),
              icon: const Icon(Icons.person_add_alt_1_outlined),
              label: Text(context.strings.buyerAddFirstButton),
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
    final TextTheme textTheme = context.textTheme;
    final ColorScheme colorScheme = context.colorScheme;

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
              context.strings.buyerNoResultsTitle,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.strings.buyerNoResultsSubtitle,
              style: textTheme.bodyMedium?.copyWith(
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
      title: context.strings.buyerScreenTitle,
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
            PopupMenuItem<String>(
              value: 'buyer',
              child: Row(
                children: <Widget>[
                  const Icon(Icons.person_add_alt_1_outlined),
                  const SizedBox(width: 8),
                  Text(context.strings.buyerMenuAddBuyer),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'sales',
              child: Row(
                children: <Widget>[
                  const Icon(Icons.local_mall_outlined),
                  const SizedBox(width: 8),
                  Text(context.strings.buyerMenuAddSale),
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
  const _BuyerCard({
    required this.buyer,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Buyer buyer;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    final ColorScheme colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withAlpha(51)),
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
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      buyer.name.isNotEmpty ? buyer.name[0].toUpperCase() : '?',
                      style: textTheme.titleLarge?.copyWith(
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
                              style: textTheme.titleMedium?.copyWith(
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
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Row(
                                      children: <Widget>[
                                        const Icon(
                                          Icons.edit_outlined,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(context.strings.buyerMenuEdit),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: <Widget>[
                                        const Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(context.strings.buyerMenuDelete),
                                      ],
                                    ),
                                  ),
                                ],
                            onSelected: (String value) {
                              if (value == 'edit') {
                                onEdit();
                              } else if (value == 'delete') {
                                onDelete();
                              }
                            },
                          ),
                        ],
                      ),
                      if (buyer.contact.isNotEmpty)
                        Text(
                          '${context.strings.buyerPhoneLabel}: ${buyer.contact}',
                          style: textTheme.bodySmall?.copyWith(
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
                context.strings.buyerAddressLabel,
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
                    context.strings.buyerAddedLabel,
                    _formatDate(buyer.createdAt, context),
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
                  label: Text(context.strings.buyerAddSaleButton),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
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
    final TextTheme textTheme = context.textTheme;
    final ColorScheme colorScheme = context.colorScheme;

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
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withAlpha(120),
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: textTheme.bodySmall?.copyWith(
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

  String _formatDate(DateTime date, BuildContext context) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.inDays == 0) {
      return context.strings.milkScreenToday;
    } else if (difference.inDays == 1) {
      return context.strings.milkScreenYesterday;
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${context.strings.buyerDaysAgo}';
    } else if (difference.inDays < 30) {
      final int weeks = (difference.inDays / 7).floor();
      return '$weeks ${context.strings.buyerWeeksAgo}';
    } else if (difference.inDays < 365) {
      final int months = (difference.inDays / 30).floor();
      return '$months ${context.strings.months}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
