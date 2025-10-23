import 'package:digital_dairy/core/routes/app_routes.dart';

import 'package:digital_dairy/core/widget/header_for_add.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MilkSalesScreen extends StatefulWidget {
  const MilkSalesScreen({super.key});

  @override
  State<MilkSalesScreen> createState() => _MilkSalesScreenState();
}

class _MilkSalesScreenState extends State<MilkSalesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) => CustomScrollView(
    controller: _scrollController,
    slivers: <Widget>[_appbar(context)],
  );

  SliverAppBar _appbar(BuildContext context) => SliverAppBar(
    backgroundColor: Colors.transparent,
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
            80, // Distance from top
            20, // Distance from right
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
