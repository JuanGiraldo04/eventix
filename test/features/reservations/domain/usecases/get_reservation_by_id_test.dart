import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:eventix/features/reservations/domain/entities/ticket.dart';
import 'package:eventix/features/reservations/domain/repositories/reservation_repository.dart';
import 'package:eventix/features/reservations/domain/usecases/get_reservation_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReservationRepository extends Mock implements ReservationRepository {}

void main() {
  late MockReservationRepository repository;
  late GetReservationById usecase;

  setUp(() {
    repository = MockReservationRepository();
    usecase = GetReservationById(repository);
  });

  group('GetReservationById', () {
    final ReservationDetail detail = ReservationDetail(
      id: 'res-1',
      eventoId: 'event-1',
      estado: 'confirmada',
      cantidadEntradas: 2,
      total: 170000,
      eventoTitulo: 'Festival de Rock',
      eventoImagenUrl: 'https://example.com/event.jpg',
      eventoFecha: DateTime(2026, 3, 5),
      eventoHora: '20:00',
      eventoCiudad: 'Bogotá',
      tickets: const <Ticket>[],
    );

    test(
      'given a reservation id '
      'when call is invoked '
      'then it calls ReservationRepository.getReservationById with the '
      'same id',
      () async {
        when(
          () => repository.getReservationById('res-1'),
        ).thenAnswer(
          (Invocation _) async => Success<ReservationDetail>(detail),
        );

        final Result<ReservationDetail> result = await usecase.call('res-1');

        expect(result, isA<Success<ReservationDetail>>());
        expect((result as Success<ReservationDetail>).data, detail);
        verify(() => repository.getReservationById('res-1')).called(1);
      },
    );

    test(
      'given the id does not match any reservation '
      'when call is invoked '
      'then it returns the same failure unchanged',
      () async {
        when(() => repository.getReservationById(any())).thenAnswer(
          (Invocation _) async =>
              const FailureResult<ReservationDetail>(NotFoundFailure()),
        );

        final Result<ReservationDetail> result = await usecase.call(
          'missing-id',
        );

        expect(result, isA<FailureResult<ReservationDetail>>());
        expect(
          (result as FailureResult<ReservationDetail>).failure,
          isA<NotFoundFailure>(),
        );
      },
    );
  });
}
