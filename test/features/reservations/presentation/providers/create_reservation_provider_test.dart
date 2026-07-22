import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/di/reservations_di.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/domain/usecases/create_reservation.dart';
import 'package:eventix/features/reservations/presentation/providers/create_reservation_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart';

class MockCreateReservation extends Mock implements CreateReservation {}

void main() {
  late MockCreateReservation createReservation;
  late ProviderContainer container;

  setUp(() {
    createReservation = MockCreateReservation();
    container = ProviderContainer(
      overrides: <Override>[
        createReservationProvider.overrideWithValue(createReservation),
      ],
    );
    addTearDown(container.dispose);
    container.listen(
      reservationCreationProvider,
      (AsyncValue<Reservation?>? _, AsyncValue<Reservation?> _) {},
    );
  });

  group('ReservationCreationNotifier', () {
    const Reservation reservation = Reservation(
      id: 'res-1',
      usuarioId: 'user-1',
      eventoId: 'event-1',
      cantidadEntradas: 1,
      total: 85000,
      estado: kReservationPendiente,
    );

    test(
      'given the notifier was just created '
      'when build runs '
      'then the initial state is AsyncData(null)',
      () {
        expect(
          container.read(reservationCreationProvider),
          const AsyncData<Reservation?>(null),
        );
      },
    );

    test(
      'given valid reservation params '
      'when create is called '
      'then state goes to loading and then to data with the reservation',
      () async {
        when(
          () => createReservation.call(
            eventoId: 'event-1',
            cantidadEntradas: 1,
            total: 85000,
          ),
        ).thenAnswer(
          (Invocation _) async => const Success<Reservation>(reservation),
        );

        final Future<void> future = container
            .read(reservationCreationProvider.notifier)
            .create(eventoId: 'event-1', cantidadEntradas: 1, total: 85000);

        expect(container.read(reservationCreationProvider).isLoading, isTrue);
        await future;

        expect(
          container.read(reservationCreationProvider).value,
          reservation,
        );
      },
    );

    test(
      'given the repository returns a failure '
      'when create is called '
      'then state goes to error with the failure',
      () async {
        when(
          () => createReservation.call(
            eventoId: any(named: 'eventoId'),
            cantidadEntradas: any(named: 'cantidadEntradas'),
            total: any(named: 'total'),
          ),
        ).thenAnswer(
          (Invocation _) async =>
              const FailureResult<Reservation>(ServerFailure()),
        );

        await container
            .read(reservationCreationProvider.notifier)
            .create(eventoId: 'event-1', cantidadEntradas: 1, total: 85000);

        final AsyncValue<Reservation?> state = container.read(
          reservationCreationProvider,
        );
        expect(state.hasError, isTrue);
        expect(state.error, isA<ServerFailure>());
      },
    );
  });
}
