import 'dart:async';

import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/events/di/events_di.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/domain/entities/event_filter.dart';
import 'package:eventix/features/events/domain/usecases/get_events.dart';
import 'package:eventix/features/events/presentation/providers/event_filter_provider.dart';
import 'package:eventix/features/events/presentation/providers/events_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart' hide Event;

class MockGetEvents extends Mock implements GetEvents {}

void main() {
  late MockGetEvents getEvents;
  late ProviderContainer container;

  Event buildEvent(String id) => Event(
    id: id,
    titulo: 'Festival de Rock',
    descripcion: 'Un festival',
    imagenUrl: 'https://example.com/event.jpg',
    categoria: 'Conciertos',
    ciudad: 'Bogotá',
    fecha: DateTime(2026, 3, 5),
    hora: '20:00',
    precio: 85000,
    capacidad: 100,
    cuposDisponibles: 40,
  );

  setUp(() {
    getEvents = MockGetEvents();
    container = ProviderContainer(
      overrides: <Override>[getEventsProvider.overrideWithValue(getEvents)],
    );
    addTearDown(container.dispose);
    // El listen se registra en cada test, DESPUÉS de configurar los stubs:
    // EventsNotifier.build() llama al usecase de inmediato, así que si se
    // escucha antes de stubear, ese primer build corre sin stub y falla.
  });

  group('EventsNotifier', () {
    test(
      'given the notifier was just created '
      'when build runs '
      'then it loads the first page of events with the default filter',
      () async {
        final Event event = buildEvent('event-1');
        when(
          () => getEvents.call(filter: const EventFilter()),
        ).thenAnswer(
          (Invocation _) async => Success<List<Event>>(<Event>[event]),
        );
        container.listen(
          eventsProvider,
          (AsyncValue<List<Event>>? _, AsyncValue<List<Event>> _) {},
        );

        final List<Event> events = await container.read(eventsProvider.future);

        expect(events, <Event>[event]);
        verify(() => getEvents.call(filter: const EventFilter())).called(1);
      },
    );

    test(
      'given the filter is applied through EventFilterNotifier '
      'when the filter changes '
      'then the events list reloads with the new filter',
      () async {
        final Event allEvents = buildEvent('event-1');
        final Event filteredEvents = buildEvent('event-2');
        // EventFilter no sobreescribe ==, y EventFilterNotifier construye una
        // instancia nueva (no const) en cada setter — se matchea por campo,
        // no por igualdad de objeto.
        when(
          () => getEvents.call(filter: const EventFilter()),
        ).thenAnswer(
          (Invocation _) async => Success<List<Event>>(<Event>[allEvents]),
        );
        when(
          () => getEvents.call(
            filter: any(
              named: 'filter',
              that: predicate<EventFilter?>(
                (EventFilter? f) => f?.categoria == 'Fútbol',
              ),
            ),
          ),
        ).thenAnswer(
          (Invocation _) async => Success<List<Event>>(<Event>[filteredEvents]),
        );
        container.listen(
          eventsProvider,
          (AsyncValue<List<Event>>? _, AsyncValue<List<Event>> _) {},
        );

        await container.read(eventsProvider.future);

        container.read(eventFilterProvider.notifier).setCategoria('Fútbol');

        final List<Event> events = await container.read(eventsProvider.future);

        expect(events, <Event>[filteredEvents]);
        verify(
          () => getEvents.call(
            filter: any(
              named: 'filter',
              that: predicate<EventFilter?>(
                (EventFilter? f) => f?.categoria == 'Fútbol',
              ),
            ),
          ),
        ).called(1);
      },
    );

    test(
      'given the repository fails '
      'when build runs '
      'then the provider surfaces the failure as AsyncError',
      () async {
        when(() => getEvents.call(filter: any(named: 'filter'))).thenAnswer(
          (Invocation _) async =>
              const FailureResult<List<Event>>(ConnectionFailure()),
        );
        final Completer<Object> completer = Completer<Object>();
        container.listen(eventsProvider, (
          AsyncValue<List<Event>>? _,
          AsyncValue<List<Event>> next,
        ) {
          if (next.hasError && !completer.isCompleted) {
            completer.complete(next.error);
          }
        });

        final Object error = await completer.future;

        expect(error, isA<ConnectionFailure>());
      },
    );
  });
}
