import 'package:eventix/core/config/app_config.dart';
import 'package:eventix/core/config/app_config_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer makeContainer() {
    final ProviderContainer container = ProviderContainer(
      retry: (int _, Object __) => null,
    );
    final ProviderSubscription<AsyncValue<AppConfig>> sub = container
        .listen<AsyncValue<AppConfig>>(appConfigProvider, (_, __) {});
    addTearDown(sub.close);
    addTearDown(container.dispose);
    return container;
  }

  group('ActiveConfigPath', () {
    test(
      'given the notifier was just created '
      'when build runs '
      'then the initial path is the default config',
      () {
        final ProviderContainer container = makeContainer();

        expect(
          container.read(activeConfigPathProvider),
          defaultConfigPath,
        );
      },
    );

    test(
      'given the default path is active '
      'when toggle is called '
      'then the path switches to the alt config',
      () {
        final ProviderContainer container = makeContainer();

        container.read(activeConfigPathProvider.notifier).toggle();

        expect(container.read(activeConfigPathProvider), altConfigPath);
      },
    );

    test(
      'given the alt path is active '
      'when toggle is called again '
      'then the path switches back to the default config',
      () {
        final ProviderContainer container = makeContainer();
        final ActiveConfigPath notifier = container.read(
          activeConfigPathProvider.notifier,
        );

        notifier.toggle();
        notifier.toggle();

        expect(container.read(activeConfigPathProvider), defaultConfigPath);
      },
    );
  });

  group('appConfigProvider', () {
    test(
      'given the default path '
      'when appConfigProvider builds '
      'then it loads and parses app_config.json',
      () async {
        final ProviderContainer container = makeContainer();

        final AppConfig config = await container.read(
          appConfigProvider.future,
        );

        expect(config.app.nombre, 'Eventix');
      },
    );

    test(
      'given the active path is toggled to the alt config '
      'when appConfigProvider rebuilds '
      'then it loads and parses app_config_alt.json',
      () async {
        final ProviderContainer container = makeContainer();
        await container.read(appConfigProvider.future);

        container.read(activeConfigPathProvider.notifier).toggle();
        final AppConfig config = await container.read(
          appConfigProvider.future,
        );

        expect(config.app.nombre, 'SportPass');
      },
    );
  });
}
