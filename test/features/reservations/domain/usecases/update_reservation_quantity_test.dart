import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/domain/repositories/reservation_repository.dart';
import 'package:eventix/features/reservations/domain/usecases/update_reservation_quantity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReservationRepository extends Mock implements ReservationRepository {}

void main() {
  late MockReservationRepository repository;
  late UpdateReservationQuantity usecase;

  setUp(() {
    repository = MockReservationRepository();
    usecase = UpdateReservationQuantity(repository);
  });

  group('UpdateReservationQuantity', () {
    const Reservation reservation = Reservation(
      id: 'res-1',
      usuarioId: 'user-1',
      eventoId: 'event-1',
      cantidadEntradas: 3,
      total: 255000,
      estado: kReservationPendiente,
    );

    test(
      'given valid params '
      'when call is invoked '
      'then it calls ReservationRepository.updateReservationQuantity with '
      'the same params',
      () async {
        when(
          () => repository.updateReservationQuantity(
            reservationId: 'res-1',
            cantidadEntradas: 3,
            total: 255000,
          ),
        ).thenAnswer(
          (Invocation _) async => const Success<Reservation>(reservation),
        );

        final Result<Reservation> result = await usecase.call(
          reservationId: 'res-1',
          cantidadEntradas: 3,
          total: 255000,
        );

        expect(result, isA<Success<Reservation>>());
        expect((result as Success<Reservation>).data, reservation);
        verify(
          () => repository.updateReservationQuantity(
            reservationId: 'res-1',
            cantidadEntradas: 3,
            total: 255000,
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
          () => repository.updateReservationQuantity(
            reservationId: any(named: 'reservationId'),
            cantidadEntradas: any(named: 'cantidadEntradas'),
            total: any(named: 'total'),
          ),
        ).thenAnswer(
          (Invocation _) async =>
              const FailureResult<Reservation>(NotFoundFailure()),
        );

        final Result<Reservation> result = await usecase.call(
          reservationId: 'missing-id',
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
}
