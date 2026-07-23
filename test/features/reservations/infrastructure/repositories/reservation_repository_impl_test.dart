import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_summary.dart';
import 'package:eventix/features/reservations/infrastructure/remote/remote_reservation_datasource.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_detail_model.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_model.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_summary_model.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_ticket_model.dart';
import 'package:eventix/features/reservations/infrastructure/repositories/reservation_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReservationRemoteDatasource extends Mock
    implements ReservationRemoteDatasource {}

RemoteReservationModel _tRemoteReservation() => const RemoteReservationModel(
  id: 'res-1',
  usuarioId: 'user-1',
  eventoId: 'event-1',
  cantidadEntradas: 2,
  total: 170000,
  estado: 'pendiente',
);

RemoteReservationSummaryModel _tRemoteReservationSummary() =>
    const RemoteReservationSummaryModel(
      id: 'res-1',
      eventoId: 'event-1',
      estado: 'confirmada',
      cantidadEntradas: 2,
      total: 170000,
      eventoTitulo: 'Festival de Rock',
      eventoImagenUrl: 'https://example.com/event.jpg',
      eventoFecha: '2026-03-05',
      eventoCiudad: 'Bogotá',
    );

RemoteReservationDetailModel _tRemoteReservationDetail() =>
    const RemoteReservationDetailModel(
      id: 'res-1',
      eventoId: 'event-1',
      estado: 'pendiente',
      cantidadEntradas: 2,
      total: 170000,
      eventoTitulo: 'Festival de Rock',
      eventoImagenUrl: 'https://example.com/event.jpg',
      eventoFecha: '2026-03-05',
      eventoHora: '20:00:00',
      eventoCiudad: 'Bogotá',
      tickets: <RemoteTicketModel>[],
    );

void main() {
  late MockReservationRemoteDatasource remoteDatasource;
  late ReservationRepositoryImpl repository;

  setUp(() {
    remoteDatasource = MockReservationRemoteDatasource();
    repository = ReservationRepositoryImpl(remoteDatasource);
  });

  group('ReservationRepositoryImpl.createReservation', () {
    test(
      'given the remote datasource returns a reservation '
      'when createReservation is called '
      'then it forwards the same params and returns the mapped entity',
      () async {
        when(
          () => remoteDatasource.createReservation(
            eventoId: 'event-1',
            cantidadEntradas: 2,
            total: 170000,
          ),
        ).thenAnswer((Invocation _) async => _tRemoteReservation());

        final Result<Reservation> result = await repository.createReservation(
          eventoId: 'event-1',
          cantidadEntradas: 2,
          total: 170000,
        );

        expect(result, isA<Success<Reservation>>());
        expect((result as Success<Reservation>).data.id, 'res-1');
      },
    );

    test(
      'given the remote datasource throws ServerFailure '
      'when createReservation is called '
      'then it returns FailureResult with the same failure',
      () async {
        when(
          () => remoteDatasource.createReservation(
            eventoId: any(named: 'eventoId'),
            cantidadEntradas: any(named: 'cantidadEntradas'),
            total: any(named: 'total'),
          ),
        ).thenThrow(const ServerFailure());

        final Result<Reservation> result = await repository.createReservation(
          eventoId: 'event-1',
          cantidadEntradas: 2,
          total: 170000,
        );

        expect(result, isA<FailureResult<Reservation>>());
        expect(
          (result as FailureResult<Reservation>).failure,
          isA<ServerFailure>(),
        );
      },
    );
  });

  group('ReservationRepositoryImpl.updateReservationQuantity', () {
    test(
      'given the remote datasource returns a reservation '
      'when updateReservationQuantity is called '
      'then it forwards the same params and returns the mapped entity',
      () async {
        when(
          () => remoteDatasource.updateReservationQuantity(
            reservationId: 'res-1',
            cantidadEntradas: 3,
            total: 255000,
          ),
        ).thenAnswer((Invocation _) async => _tRemoteReservation());

        final Result<Reservation> result = await repository
            .updateReservationQuantity(
              reservationId: 'res-1',
              cantidadEntradas: 3,
              total: 255000,
            );

        expect(result, isA<Success<Reservation>>());
      },
    );

    test(
      'given the remote datasource throws NotFoundFailure '
      'when updateReservationQuantity is called '
      'then it returns FailureResult with the same failure',
      () async {
        when(
          () => remoteDatasource.updateReservationQuantity(
            reservationId: any(named: 'reservationId'),
            cantidadEntradas: any(named: 'cantidadEntradas'),
            total: any(named: 'total'),
          ),
        ).thenThrow(const NotFoundFailure());

        final Result<Reservation> result = await repository
            .updateReservationQuantity(
              reservationId: 'missing',
              cantidadEntradas: 3,
              total: 255000,
            );

        expect(result, isA<FailureResult<Reservation>>());
        expect(
          (result as FailureResult<Reservation>).failure,
          isA<NotFoundFailure>(),
        );
      },
    );
  });

  group('ReservationRepositoryImpl.confirmReservation', () {
    test(
      'given the remote datasource returns a reservation '
      'when confirmReservation is called '
      'then it forwards the same id and returns the mapped entity',
      () async {
        when(
          () => remoteDatasource.confirmReservation('res-1'),
        ).thenAnswer((Invocation _) async => _tRemoteReservation());

        final Result<Reservation> result = await repository.confirmReservation(
          'res-1',
        );

        expect(result, isA<Success<Reservation>>());
        verify(() => remoteDatasource.confirmReservation('res-1')).called(1);
      },
    );

    test(
      'given the remote datasource throws ConnectionFailure '
      'when confirmReservation is called '
      'then it returns FailureResult with the same failure',
      () async {
        when(
          () => remoteDatasource.confirmReservation(any()),
        ).thenThrow(const ConnectionFailure());

        final Result<Reservation> result = await repository.confirmReservation(
          'res-1',
        );

        expect(result, isA<FailureResult<Reservation>>());
        expect(
          (result as FailureResult<Reservation>).failure,
          isA<ConnectionFailure>(),
        );
      },
    );
  });

  group('ReservationRepositoryImpl.getMyReservations', () {
    test(
      'given the remote datasource returns reservation summaries '
      'when getMyReservations is called '
      'then it returns the mapped entities',
      () async {
        when(remoteDatasource.getMyReservations).thenAnswer(
          (Invocation _) async => <RemoteReservationSummaryModel>[
            _tRemoteReservationSummary(),
          ],
        );

        final Result<List<ReservationSummary>> result = await repository
            .getMyReservations();

        expect(result, isA<Success<List<ReservationSummary>>>());
        expect(
          (result as Success<List<ReservationSummary>>).data.first.id,
          'res-1',
        );
      },
    );

    test(
      'given the remote datasource throws ConnectionFailure '
      'when getMyReservations is called '
      'then it returns FailureResult with the same failure',
      () async {
        when(
          remoteDatasource.getMyReservations,
        ).thenThrow(const ConnectionFailure());

        final Result<List<ReservationSummary>> result = await repository
            .getMyReservations();

        expect(result, isA<FailureResult<List<ReservationSummary>>>());
        expect(
          (result as FailureResult<List<ReservationSummary>>).failure,
          isA<ConnectionFailure>(),
        );
      },
    );
  });

  group('ReservationRepositoryImpl.getReservationById', () {
    test(
      'given the remote datasource returns a reservation detail '
      'when getReservationById is called '
      'then it forwards the same id and returns the mapped entity',
      () async {
        when(
          () => remoteDatasource.getReservationById('res-1'),
        ).thenAnswer((Invocation _) async => _tRemoteReservationDetail());

        final Result<ReservationDetail> result = await repository
            .getReservationById('res-1');

        expect(result, isA<Success<ReservationDetail>>());
        expect(
          (result as Success<ReservationDetail>).data.eventoTitulo,
          'Festival de Rock',
        );
        verify(
          () => remoteDatasource.getReservationById('res-1'),
        ).called(1);
      },
    );

    test(
      'given the remote datasource throws NotFoundFailure '
      'when getReservationById is called '
      'then it returns FailureResult with the same failure',
      () async {
        when(
          () => remoteDatasource.getReservationById(any()),
        ).thenThrow(const NotFoundFailure());

        final Result<ReservationDetail> result = await repository
            .getReservationById('missing');

        expect(result, isA<FailureResult<ReservationDetail>>());
        expect(
          (result as FailureResult<ReservationDetail>).failure,
          isA<NotFoundFailure>(),
        );
      },
    );
  });
}
