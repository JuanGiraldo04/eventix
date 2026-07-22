import 'dart:async';

import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/di/reservations_di.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:eventix/features/reservations/domain/entities/ticket.dart';
import 'package:eventix/features/reservations/domain/usecases/get_reservation_by_id.dart';
import 'package:eventix/features/reservations/presentation/providers/reservation_detail_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart';

class MockGetReservationById extends Mock implements GetReservationById {}

void main() {
  late MockGetReservationById getReservationById;
  late ProviderContainer container;

  setUp(() {
    getReservationById = MockGetReservationById();
    container = ProviderContainer(
      overrides: <Override>[
        getReservationByIdProvider.overrideWithValue(getReservationById),
      ],
    );
    addTearDown(container.dispose);
  });

  group('ReservationDetailNotifier', () {
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
      'when build runs '
      'then it calls GetReservationById with the same id and returns the '
      'detail',
      () async {
        when(
          () => getReservationById.call('res-1'),
        ).thenAnswer(
          (Invocation _) async => Success<ReservationDetail>(detail),
        );
        container.listen(
          reservationDetailProvider('res-1'),
          (
            AsyncValue<ReservationDetail>? _,
            AsyncValue<ReservationDetail> _,
          ) {},
        );

        final ReservationDetail result = await container.read(
          reservationDetailProvider('res-1').future,
        );

        expect(result, detail);
        verify(() => getReservationById.call('res-1')).called(1);
      },
    );

    test(
      'given the id does not match any reservation '
      'when build runs '
      'then the provider surfaces the failure as AsyncError',
      () async {
        when(() => getReservationById.call(any())).thenAnswer(
          (Invocation _) async =>
              const FailureResult<ReservationDetail>(NotFoundFailure()),
        );
        final Completer<Object> completer = Completer<Object>();
        container.listen(reservationDetailProvider('missing-id'), (
          AsyncValue<ReservationDetail>? _,
          AsyncValue<ReservationDetail> next,
        ) {
          if (next.hasError && !completer.isCompleted) {
            completer.complete(next.error);
          }
        });

        final Object error = await completer.future;

        expect(error, isA<NotFoundFailure>());
      },
    );
  });
}
