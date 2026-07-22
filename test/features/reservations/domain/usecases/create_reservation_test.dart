import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/domain/repositories/reservation_repository.dart';
import 'package:eventix/features/reservations/domain/usecases/create_reservation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReservationRepository extends Mock implements ReservationRepository {}

void main() {
  late MockReservationRepository repository;
  late CreateReservation usecase;

  setUp(() {
    repository = MockReservationRepository();
    usecase = CreateReservation(repository);
  });

  group('CreateReservation', () {
    const Reservation reservation = Reservation(
      id: 'res-1',
      usuarioId: 'user-1',
      eventoId: 'event-1',
      cantidadEntradas: 2,
      total: 170000,
      estado: kReservationPendiente,
    );

    test(
      'given valid reservation params '
      'when call is invoked '
      'then it calls ReservationRepository.createReservation with the same '
      'params',
      () async {
        when(
          () => repository.createReservation(
            eventoId: 'event-1',
            cantidadEntradas: 2,
            total: 170000,
          ),
        ).thenAnswer(
          (Invocation _) async => const Success<Reservation>(reservation),
        );

        final Result<Reservation> result = await usecase.call(
          eventoId: 'event-1',
          cantidadEntradas: 2,
          total: 170000,
        );

        expect(result, isA<Success<Reservation>>());
        expect((result as Success<Reservation>).data, reservation);
        verify(
          () => repository.createReservation(
            eventoId: 'event-1',
            cantidadEntradas: 2,
            total: 170000,
          ),
        ).called(1);
      },
    );

    test(
      'given the repository returns a failure '
      'when call is invoked '
      'then it returns the same failure unchanged',
      () async {
        when(
          () => repository.createReservation(
            eventoId: any(named: 'eventoId'),
            cantidadEntradas: any(named: 'cantidadEntradas'),
            total: any(named: 'total'),
          ),
        ).thenAnswer(
          (Invocation _) async =>
              const FailureResult<Reservation>(ServerFailure()),
        );

        final Result<Reservation> result = await usecase.call(
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
}
