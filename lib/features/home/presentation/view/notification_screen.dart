import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

///
class NotificationScreen extends StatelessWidget {
  ///
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.strings.notificationScreenTitle)),
    body: Center(child: Text(context.strings.comingSoon)),
  );
}
