import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/src/framework.dart';

/// Envuelve [child] en un ProviderScope (con [overrides]) + MaterialApp con
/// el tema y los delegates de localización reales de la app, replicando el
/// árbol de widgets que [MainApp] arma en producción — así las páginas que
/// leen `AppLocalizations.of(context)`/`Theme.of(context)` funcionan igual
/// que en la app real.
Future<void> pumpPage(
  WidgetTester tester, {
  required Widget child,
  List<Override> overrides = const <Override>[],
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    ),
  );
}
