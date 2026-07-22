import 'dart:async';

import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/events/di/events_di.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/domain/usecases/get_event_by_id.dart';
import 'package:eventix/features/reservations/di/reservations_di.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:eventix/features/reservations/domain/entities/ticket.dart';
import 'package:eventix/features/reservations/domain/usecases/get_reservation_by_id.dart';
import 'package:eventix/features/reservations/presentation/providers/checkout_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart' hide Event;

class MockGetReservationById extends Mock implements GetReservationById {}

class MockGetEventById extends Mock implements GetEventById {}

void main() {
  late MockGetReservationById getReservationById;
  late MockGetEventById getEventById;
  late ProviderContainer container;

  final ReservationDetail detail = ReservationDetail(
    id: 'res-1',
    eventoId: 'event-1',
    estado: 'pendiente',
    cantidadEntradas: 1,
    total: 85000,
    eventoTitulo: 'Festival de Rock',
    eventoImagenUrl: 'https://example.com/event.jpg',
    eventoFecha: DateTime(2026, 3, 5),
    eventoHora: '20:00',
    eventoCiudad: 'Bogotá',
    tickets: const <Ticket>[],
  );

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

  setUp(() {
    getReservationById = MockGetReservationById();
    getEventById = MockGetEventById();
    container = ProviderContainer(
      overrides: <Override>[
        getReservationByIdProvider.overrideWithValue(getReservationById),
        getEventByIdProvider.overrideWithValue(getEventById),
      ],
    );
    addTearDown(container.dispose);
  });

  group('CheckoutNotifier', () {
    test(
      'given the reservation and its event both load '
      'when build runs '
      'then it fetches the event using the reservation\'s eventoId and '
      'combines both into CheckoutData',
      () async {
        when(
          () => getReservationById.call('res-1'),
        ).thenAnswer(
          (Invocation _) async => Success<ReservationDetail>(detail),
        );
        when(
          () => getEventById.call('event-1'),
        ).thenAnswer((Invocation _) async => Success<Event>(event));
        container.listen(
          checkoutProvider('res-1'),
          (AsyncValue<CheckoutData>? _, AsyncValue<CheckoutData> _) {},
        );

        final CheckoutData result = await container.read(
          checkoutProvider('res-1').future,
        );

        expect(result.reservation, detail);
        expect(result.event, event);
        verify(() => getEventById.call('event-1')).called(1);
      },
    );

    test(
      'given the reservation fails to load '
      'when build runs '
      'then the provider surfaces the failure and never fetches the event',
      () async {
        when(() => getReservationById.call(any())).thenAnswer(
          (Invocation _) async =>
              const FailureResult<ReservationDetail>(NotFoundFailure()),
        );
        final Completer<Object> completer = Completer<Object>();
        container.listen(checkoutProvider('missing-id'), (
          AsyncValue<CheckoutData>? _,
          AsyncValue<CheckoutData> next,
        ) {
          if (next.hasError && !completer.isCompleted) {
            completer.complete(next.error);
          }
        });

        final Object error = await completer.future;

        expect(error, isA<NotFoundFailure>());
        verifyNever(() => getEventById.call(any()));
      },
    );

    test(
      'given the reservation loads but its event fails to load '
      'when build runs '
      'then the provider surfaces the event failure',
      () async {
        when(
          () => getReservationById.call('res-1'),
        ).thenAnswer(
          (Invocation _) async => Success<ReservationDetail>(detail),
        );
        when(() => getEventById.call('event-1')).thenAnswer(
          (Invocation _) async =>
              const FailureResult<Event>(ConnectionFailure()),
        );
        final Completer<Object> completer = Completer<Object>();
        container.listen(checkoutProvider('res-1'), (
          AsyncValue<CheckoutData>? _,
          AsyncValue<CheckoutData> next,
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
