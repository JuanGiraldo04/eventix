import 'dart:async';

import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/events/di/events_di.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/domain/usecases/get_event_by_id.dart';
import 'package:eventix/features/events/presentation/providers/event_detail_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart' hide Event;

class MockGetEventById extends Mock implements GetEventById {}

void main() {
  late MockGetEventById getEventById;
  late ProviderContainer container;

  setUp(() {
    getEventById = MockGetEventById();
    container = ProviderContainer(
      overrides: <Override>[
        getEventByIdProvider.overrideWithValue(getEventById),
      ],
    );
    addTearDown(container.dispose);
  });

  group('EventDetailNotifier', () {
    final Event event = Event(
      id: 'event-1',
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

    test(
      'given an event id '
      'when build runs '
      'then it calls GetEventById with the same id and returns the event',
      () async {
        when(
          () => getEventById.call('event-1'),
        ).thenAnswer((Invocation _) async => Success<Event>(event));
        // Mantiene vivo el AsyncNotifier autoDispose mientras se resuelve.
        container.listen(eventDetailProvider('event-1'), (_, _) {});

        final Event result = await container.read(
          eventDetailProvider('event-1').future,
        );

        expect(result, event);
        verify(() => getEventById.call('event-1')).called(1);
      },
    );

    test(
      'given the id does not match any event '
      'when build runs '
      'then the provider surfaces the failure as AsyncError',
      () async {
        when(() => getEventById.call(any())).thenAnswer(
          (Invocation _) async => const FailureResult<Event>(NotFoundFailure()),
        );
        final Completer<Object> completer = Completer<Object>();
        container.listen(eventDetailProvider('missing-id'), (
          AsyncValue<Event>? _,
          AsyncValue<Event> next,
        ) {
          if (next.hasError && !completer.isCompleted) {
            completer.complete(next.error);
          }
        });

        final Object error = await completer.future;

        expect(error, isA<NotFoundFailure>());
      },
    );
  });
}
