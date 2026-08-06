import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/config/app_config.dart';
import 'package:eventix/core/config/app_config_provider.dart';
import 'package:eventix/core/env/env.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/core/router/app_router.dart';
import 'package:eventix/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
  );
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode = ref.watch(themeModeProvider);
    final AsyncValue<AppConfig> asyncConfig = ref.watch(appConfigProvider);

    return asyncConfig.when(
      loading: () => _ConfigStatusApp(
        themeMode: themeMode,
        child: const Center(child: AppLoader(size: AppLoaderSize.large)),
      ),
      error: (Object error, StackTrace _) => _ConfigStatusApp(
        themeMode: themeMode,
        child: Builder(
          builder: (BuildContext context) => AppErrorState(
            message: AppLocalizations.of(context).common_unexpected_error,
            onRetry: () => ref.invalidate(appConfigProvider),
          ),
        ),
      ),
      data: (AppConfig config) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateTitle: (BuildContext context) => config.app.nombre,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        routerConfig: appRouter,
      ),
    );
  }
}

class _ConfigStatusApp extends StatelessWidget {
  const _ConfigStatusApp({required this.themeMode, required this.child});

  final ThemeMode themeMode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: Scaffold(body: child),
    );
  }
}
