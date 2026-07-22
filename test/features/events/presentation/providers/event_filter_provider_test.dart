import 'package:eventix/features/events/domain/entities/event_filter.dart';
import 'package:eventix/features/events/presentation/providers/event_filter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
    container.listen(eventFilterProvider, (EventFilter? _, EventFilter _) {});
  });

  group('EventFilterNotifier', () {
    test(
      'given the notifier was just created '
      'when build runs '
      'then the initial state is an empty EventFilter',
      () {
        expect(container.read(eventFilterProvider), const EventFilter());
      },
    );

    test(
      'given an existing filter '
      'when setQuery is called '
      'then only the query field changes',
      () {
        container.read(eventFilterProvider.notifier).setCategoria('Fútbol');
        container.read(eventFilterProvider.notifier).setQuery('rock');

        final EventFilter filter = container.read(eventFilterProvider);
        expect(filter.query, 'rock');
        expect(filter.categoria, 'Fútbol');
      },
    );

    test(
      'given an existing filter '
      'when setCategoria is called '
      'then only the categoria field changes',
      () {
        container.read(eventFilterProvider.notifier).setQuery('rock');
        container.read(eventFilterProvider.notifier).setCategoria('Fútbol');

        final EventFilter filter = container.read(eventFilterProvider);
        expect(filter.categoria, 'Fútbol');
        expect(filter.query, 'rock');
      },
    );

    test(
      'given an existing filter '
      'when setCiudad is called '
      'then only the ciudad field changes',
      () {
        container.read(eventFilterProvider.notifier).setQuery('rock');
        container.read(eventFilterProvider.notifier).setCiudad('Bogotá');

        final EventFilter filter = container.read(eventFilterProvider);
        expect(filter.ciudad, 'Bogotá');
        expect(filter.query, 'rock');
      },
    );

    test(
      'given an existing filter '
      'when setFecha is called '
      'then only the fecha field changes',
      () {
        final DateTime fecha = DateTime(2026, 3, 5);
        container.read(eventFilterProvider.notifier).setQuery('rock');
        container.read(eventFilterProvider.notifier).setFecha(fecha);

        final EventFilter filter = container.read(eventFilterProvider);
        expect(filter.fecha, fecha);
        expect(filter.query, 'rock');
      },
    );

    test(
      'given a filter with every field set '
      'when clear is called '
      'then the filter resets to the default empty EventFilter',
      () {
        container.read(eventFilterProvider.notifier)
          ..setQuery('rock')
          ..setCategoria('Fútbol')
          ..setCiudad('Bogotá')
          ..setFecha(DateTime(2026, 3, 5));

        container.read(eventFilterProvider.notifier).clear();

        expect(container.read(eventFilterProvider), const EventFilter());
      },
    );
  });
}
