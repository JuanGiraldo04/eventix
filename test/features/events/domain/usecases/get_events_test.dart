import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/domain/entities/event_filter.dart';
import 'package:eventix/features/events/domain/repositories/event_repository.dart';
import 'package:eventix/features/events/domain/usecases/get_events.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventRepository extends Mock implements EventRepository {}

void main() {
  late MockEventRepository repository;
  late GetEvents usecase;

  setUp(() {
    repository = MockEventRepository();
    usecase = GetEvents(repository);
  });

  group('GetEvents', () {
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
      'given a filter '
      'when call is invoked '
      'then it calls EventRepository.getEvents with the same filter',
      () async {
        const EventFilter filter = EventFilter(
          categoria: 'Conciertos',
          ciudad: 'Bogotá',
        );
        when(
          () => repository.getEvents(filter: filter),
        ).thenAnswer(
          (Invocation _) async => Success<List<Event>>(<Event>[event]),
        );

        final Result<List<Event>> result = await usecase.call(filter: filter);

        expect(result, isA<Success<List<Event>>>());
        expect((result as Success<List<Event>>).data, <Event>[event]);
        verify(() => repository.getEvents(filter: filter)).called(1);
      },
    );

    test(
      'given no filter '
      'when call is invoked '
      'then it calls EventRepository.getEvents with a null filter',
      () async {
        when(
          () => repository.getEvents(),
        ).thenAnswer(
          (Invocation _) async => Success<List<Event>>(<Event>[event]),
        );

        await usecase.call();

        verify(() => repository.getEvents()).called(1);
      },
    );

    test(
      'given the repository returns a failure '
      'when call is invoked '
      'then it returns the same failure unchanged',
      () async {
        when(
          () => repository.getEvents(filter: any(named: 'filter')),
        ).thenAnswer(
          (Invocation _) async =>
              const FailureResult<List<Event>>(ConnectionFailure()),
        );

        final Result<List<Event>> result = await usecase.call();

        expect(result, isA<FailureResult<List<Event>>>());
        expect(
          (result as FailureResult<List<Event>>).failure,
          isA<ConnectionFailure>(),
        );
      },
    );
  });
}
