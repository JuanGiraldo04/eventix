import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/domain/entities/event_filter.dart';
import 'package:eventix/features/events/infrastructure/remote/remote_event_datasource.dart';
import 'package:eventix/features/events/infrastructure/remote/supabase/models/remote_event_model.dart';
import 'package:eventix/features/events/infrastructure/repositories/event_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventRemoteDatasource extends Mock implements EventRemoteDatasource {}

RemoteEventModel _tRemoteEvent() => const RemoteEventModel(
  id: 'event-1',
  titulo: 'Festival de Rock',
  descripcion: 'Un festival',
  imagenUrl: 'https://example.com/event.jpg',
  categoria: 'Conciertos',
  ciudad: 'Bogotá',
  fecha: '2026-03-05',
  hora: '20:00:00',
  precio: 85000,
  capacidad: 100,
  cuposDisponibles: 40,
);

void main() {
  late MockEventRemoteDatasource remoteDatasource;
  late EventRepositoryImpl repository;

  setUp(() {
    remoteDatasource = MockEventRemoteDatasource();
    repository = EventRepositoryImpl(remoteDatasource);
  });

  group('EventRepositoryImpl.getEvents', () {
    test(
      'given the remote datasource returns events '
      'when getEvents is called with a filter '
      'then it forwards the same filter '
      'and returns the mapped entities',
      () async {
        const EventFilter filter = EventFilter(categoria: 'Fútbol');
        when(
          () => remoteDatasource.getEvents(filter: filter),
        ).thenAnswer(
          (Invocation _) async => <RemoteEventModel>[_tRemoteEvent()],
        );

        final Result<List<Event>> result = await repository.getEvents(
          filter: filter,
        );

        expect(result, isA<Success<List<Event>>>());
        expect((result as Success<List<Event>>).data.first.id, 'event-1');
        verify(() => remoteDatasource.getEvents(filter: filter)).called(1);
      },
    );

    test(
      'given the remote datasource throws ConnectionFailure '
      'when getEvents is called '
      'then it returns FailureResult with the same failure',
      () async {
        when(
          () => remoteDatasource.getEvents(filter: any(named: 'filter')),
        ).thenThrow(const ConnectionFailure());

        final Result<List<Event>> result = await repository.getEvents();

        expect(result, isA<FailureResult<List<Event>>>());
        expect(
          (result as FailureResult<List<Event>>).failure,
          isA<ConnectionFailure>(),
        );
      },
    );
  });

  group('EventRepositoryImpl.getEventById', () {
    test(
      'given the remote datasource returns an event '
      'when getEventById is called '
      'then it forwards the same id '
      'and returns the mapped entity',
      () async {
        when(
          () => remoteDatasource.getEventById('event-1'),
        ).thenAnswer((Invocation _) async => _tRemoteEvent());

        final Result<Event> result = await repository.getEventById('event-1');

        expect(result, isA<Success<Event>>());
        expect((result as Success<Event>).data.titulo, 'Festival de Rock');
        verify(() => remoteDatasource.getEventById('event-1')).called(1);
      },
    );

    test(
      'given the remote datasource throws NotFoundFailure '
      'when getEventById is called '
      'then it returns FailureResult with the same failure',
      () async {
        when(
          () => remoteDatasource.getEventById(any()),
        ).thenThrow(const NotFoundFailure());

        final Result<Event> result = await repository.getEventById(
          'missing',
        );

        expect(result, isA<FailureResult<Event>>());
        expect(
          (result as FailureResult<Event>).failure,
          isA<NotFoundFailure>(),
        );
      },
    );
  });
}
