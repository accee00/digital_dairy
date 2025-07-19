import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colorScheme.primary.withAlpha(100),
              colorScheme.surface,
              colorScheme.secondary.withAlpha(90),
            ],
          ),
        ),
        child: Column(children: [
            
          ],
        ),
      ),
    );
  }
}
