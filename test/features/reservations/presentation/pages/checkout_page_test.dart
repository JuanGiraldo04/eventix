import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/events/di/events_di.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/domain/usecases/get_event_by_id.dart';
import 'package:eventix/features/events/presentation/utils/event_formatters.dart';
import 'package:eventix/features/reservations/di/reservations_di.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:eventix/features/reservations/domain/entities/ticket.dart';
import 'package:eventix/features/reservations/domain/usecases/get_reservation_by_id.dart';
import 'package:eventix/features/reservations/presentation/pages/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart' show Override;

import '../../../../helpers/pump_page.dart';

class MockGetReservationById extends Mock implements GetReservationById {}

class MockGetEventById extends Mock implements GetEventById {}

void main() {
  late MockGetReservationById getReservationById;
  late MockGetEventById getEventById;

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
    when(
      () => getReservationById.call('res-1'),
    ).thenAnswer((Invocation _) async => Success<ReservationDetail>(detail));
    when(
      () => getEventById.call('event-1'),
    ).thenAnswer((Invocation _) async => Success<Event>(event));
  });

  Finder totalValueText(String text) => find.descendant(
    of: find.byWidgetPredicate(
      (Widget w) => w is AppCard && w.variant == AppCardVariant.filled,
    ),
    matching: find.text(text),
  );

  Future<void> pumpCheckout(WidgetTester tester) async {
    await pumpPage(
      tester,
      overrides: <Override>[
        getReservationByIdProvider.overrideWithValue(getReservationById),
        getEventByIdProvider.overrideWithValue(getEventById),
      ],
      child: const CheckoutPage(reservationId: 'res-1'),
    );
    await tester.pumpAndSettle();
  }

  group('CheckoutPage', () {
    testWidgets('shows the event name', (WidgetTester tester) async {
      await pumpCheckout(tester);

      expect(find.text('Festival de Rock'), findsOneWidget);
    });

    testWidgets(
      'the AppStepper increments the quantity and the total updates',
      (WidgetTester tester) async {
        await pumpCheckout(tester);

        expect(totalValueText(formatEventPrecio(85000)), findsOneWidget);

        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.pumpAndSettle();

        expect(find.text('2'), findsOneWidget);
        expect(totalValueText(formatEventPrecio(170000)), findsOneWidget);
        expect(totalValueText(formatEventPrecio(85000)), findsNothing);
      },
    );

    testWidgets(
      'the AppStepper decrements the quantity and the total updates back',
      (WidgetTester tester) async {
        await pumpCheckout(tester);

        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.pumpAndSettle();

        expect(find.text('1'), findsOneWidget);
        expect(totalValueText(formatEventPrecio(85000)), findsOneWidget);
      },
    );
  });
}
