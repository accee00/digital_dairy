import 'package:digital_dairy/core/bloc/locale_bloc.dart';
import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final List<Map<String, String>> _languages = <Map<String, String>>[
  <String, String>{'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
  <String, String>{'code': 'hi', 'name': 'हिंदी', 'flag': '🇮🇳'},
];

///
void showLanguageSelectionDialog({required BuildContext context}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              context.colorScheme.surface,
              context.colorScheme.primary.withAlpha(20),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.language_rounded,
              size: 48,
              color: context.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Choose Your Language',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select your preferred language to continue',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withAlpha(180),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: SingleChildScrollView(
                child: Column(
                  children: _languages
                      .map(
                        (Map<String, String> language) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                context.read<LocaleBloc>().add(
                                  LocaleChangeEvent(
                                    Locale(language['code']!),
                                    hasShownLanguageDialog: true,
                                  ),
                                );
                                context.pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: context.colorScheme.outline
                                        .withAlpha(100),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      language['flag']!,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        language['name']!,
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
