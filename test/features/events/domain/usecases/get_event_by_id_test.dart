import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/domain/repositories/event_repository.dart';
import 'package:eventix/features/events/domain/usecases/get_event_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventRepository extends Mock implements EventRepository {}

void main() {
  late MockEventRepository repository;
  late GetEventById usecase;

  setUp(() {
    repository = MockEventRepository();
    usecase = GetEventById(repository);
  });

  group('GetEventById', () {
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
      'when call is invoked '
      'then it calls EventRepository.getEventById with the same id',
      () async {
        when(
          () => repository.getEventById('event-1'),
        ).thenAnswer((Invocation _) async => Success<Event>(event));

        final Result<Event> result = await usecase.call('event-1');

        expect(result, isA<Success<Event>>());
        expect((result as Success<Event>).data, event);
        verify(() => repository.getEventById('event-1')).called(1);
      },
    );

    test(
      'given the id does not match any event '
      'when call is invoked '
      'then it returns the same failure unchanged',
      () async {
        when(() => repository.getEventById(any())).thenAnswer(
          (Invocation _) async => const FailureResult<Event>(NotFoundFailure()),
        );

        final Result<Event> result = await usecase.call('missing-id');

        expect(result, isA<FailureResult<Event>>());
        expect(
          (result as FailureResult<Event>).failure,
          isA<NotFoundFailure>(),
        );
      },
    );
  });
}
