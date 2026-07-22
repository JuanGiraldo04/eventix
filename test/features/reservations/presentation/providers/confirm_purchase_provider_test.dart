import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/di/reservations_di.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/domain/usecases/confirm_reservation.dart';
import 'package:eventix/features/reservations/domain/usecases/update_reservation_quantity.dart';
import 'package:eventix/features/reservations/presentation/providers/confirm_purchase_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart';

class MockUpdateReservationQuantity extends Mock
    implements UpdateReservationQuantity {}

class MockConfirmReservation extends Mock implements ConfirmReservation {}

void main() {
  late MockUpdateReservationQuantity updateReservationQuantity;
  late MockConfirmReservation confirmReservation;
  late ProviderContainer container;

  setUp(() {
    updateReservationQuantity = MockUpdateReservationQuantity();
    confirmReservation = MockConfirmReservation();
    container = ProviderContainer(
      overrides: <Override>[
        updateReservationQuantityProvider.overrideWithValue(
          updateReservationQuantity,
        ),
        confirmReservationProvider.overrideWithValue(confirmReservation),
      ],
    );
    addTearDown(container.dispose);
    container.listen(
      confirmPurchaseProvider,
      (AsyncValue<Reservation?>? _, AsyncValue<Reservation?> _) {},
    );
  });

  group('ConfirmPurchaseNotifier', () {
    const Reservation updatedReservation = Reservation(
      id: 'res-1',
      usuarioId: 'user-1',
      eventoId: 'event-1',
      cantidadEntradas: 2,
      total: 170000,
      estado: kReservationPendiente,
    );
    const Reservation confirmedReservation = Reservation(
      id: 'res-1',
      usuarioId: 'user-1',
      eventoId: 'event-1',
      cantidadEntradas: 2,
      total: 170000,
      estado: kReservationConfirmada,
    );

    test(
      'given both steps succeed '
      'when confirmPurchase is called '
      'then state ends with the confirmed reservation',
      () async {
        when(
          () => updateReservationQuantity.call(
            reservationId: 'res-1',
            cantidadEntradas: 2,
            total: 170000,
          ),
        ).thenAnswer(
          (Invocation _) async =>
              const Success<Reservation>(updatedReservation),
        );
        when(
          () => confirmReservation.call('res-1'),
        ).thenAnswer(
          (Invocation _) async =>
              const Success<Reservation>(confirmedReservation),
        );

        final Future<void> future = container
            .read(confirmPurchaseProvider.notifier)
            .confirmPurchase(
              reservationId: 'res-1',
              cantidadEntradas: 2,
              total: 170000,
            );

        expect(container.read(confirmPurchaseProvider).isLoading, isTrue);
        await future;

        expect(
          container.read(confirmPurchaseProvider).value,
          confirmedReservation,
        );
      },
    );

    test(
      'given updating the quantity fails '
      'when confirmPurchase is called '
      'then state goes to error and confirmReservation is never called',
      () async {
        when(
          () => updateReservationQuantity.call(
            reservationId: any(named: 'reservationId'),
            cantidadEntradas: any(named: 'cantidadEntradas'),
            total: any(named: 'total'),
          ),
        ).thenAnswer(
          (Invocation _) async =>
              const FailureResult<Reservation>(ServerFailure()),
        );

        await container
            .read(confirmPurchaseProvider.notifier)
            .confirmPurchase(
              reservationId: 'res-1',
              cantidadEntradas: 2,
              total: 170000,
            );

        final AsyncValue<Reservation?> state = container.read(
          confirmPurchaseProvider,
        );
        expect(state.hasError, isTrue);
        expect(state.error, isA<ServerFailure>());
        verifyNever(() => confirmReservation.call(any()));
      },
    );

    test(
      'given the quantity update succeeds but confirmation fails '
      'when confirmPurchase is called '
      'then state goes to error with the confirmation failure',
      () async {
        when(
          () => updateReservationQuantity.call(
            reservationId: any(named: 'reservationId'),
            cantidadEntradas: any(named: 'cantidadEntradas'),
            total: any(named: 'total'),
          ),
        ).thenAnswer(
          (Invocation _) async =>
              const Success<Reservation>(updatedReservation),
        );
        when(() => confirmReservation.call(any())).thenAnswer(
          (Invocation _) async =>
              const FailureResult<Reservation>(NotFoundFailure()),
        );

        await container
            .read(confirmPurchaseProvider.notifier)
            .confirmPurchase(
              reservationId: 'res-1',
              cantidadEntradas: 2,
              total: 170000,
            );

        final AsyncValue<Reservation?> state = container.read(
          confirmPurchaseProvider,
        );
        expect(state.hasError, isTrue);
        expect(state.error, isA<NotFoundFailure>());
      },
    );
  });
}
