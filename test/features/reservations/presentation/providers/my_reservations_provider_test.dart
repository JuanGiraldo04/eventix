import 'dart:async';

import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/di/reservations_di.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_summary.dart';
import 'package:eventix/features/reservations/domain/usecases/get_my_reservations.dart';
import 'package:eventix/features/reservations/presentation/providers/my_reservations_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart';

class MockGetMyReservations extends Mock implements GetMyReservations {}

void main() {
  late MockGetMyReservations getMyReservations;
  late ProviderContainer container;

  setUp(() {
    getMyReservations = MockGetMyReservations();
    container = ProviderContainer(
      overrides: <Override>[
        getMyReservationsProvider.overrideWithValue(getMyReservations),
      ],
    );
    addTearDown(container.dispose);
    // El listen se registra en cada test, DESPUÉS de configurar los stubs:
    // MyReservationsNotifier.build() llama al usecase de inmediato.
  });

  group('MyReservationsNotifier', () {
    final ReservationSummary summary = ReservationSummary(
      id: 'res-1',
      eventoId: 'event-1',
      estado: 'confirmada',
      cantidadEntradas: 2,
      total: 170000,
      eventoTitulo: 'Festival de Rock',
      eventoImagenUrl: 'https://example.com/event.jpg',
      eventoFecha: DateTime(2026, 3, 5),
      eventoCiudad: 'Bogotá',
    );

    test(
      'given the user has reservations '
      'when build runs '
      'then it returns the list of reservation summaries',
      () async {
        when(getMyReservations.call).thenAnswer(
          (Invocation _) async =>
              Success<List<ReservationSummary>>(<ReservationSummary>[summary]),
        );
        container.listen(
          myReservationsProvider,
          (
            AsyncValue<List<ReservationSummary>>? _,
            AsyncValue<List<ReservationSummary>> _,
          ) {},
        );

        final List<ReservationSummary> result = await container.read(
          myReservationsProvider.future,
        );

        expect(result, <ReservationSummary>[summary]);
      },
    );

    test(
      'given the repository fails '
      'when build runs '
      'then the provider surfaces the failure as AsyncError',
      () async {
        when(getMyReservations.call).thenAnswer(
          (Invocation _) async => const FailureResult<List<ReservationSummary>>(
            ConnectionFailure(),
          ),
        );
        final Completer<Object> completer = Completer<Object>();
        container.listen(myReservationsProvider, (
          AsyncValue<List<ReservationSummary>>? _,
          AsyncValue<List<ReservationSummary>> next,
        ) {
          if (next.hasError && !completer.isCompleted) {
            completer.complete(next.error);
          }
        });

        final Object error = await completer.future;

        expect(error, isA<ConnectionFailure>());
      },
    );
  });
}
