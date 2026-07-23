import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/reservations/di/reservations_di.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_summary.dart';
import 'package:eventix/features/reservations/domain/usecases/get_my_reservations.dart';
import 'package:eventix/features/reservations/presentation/pages/reservations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart' show Override;

import '../../../../helpers/pump_page.dart';

class MockGetMyReservations extends Mock implements GetMyReservations {}

void main() {
  late MockGetMyReservations getMyReservations;

  ReservationSummary buildSummary({
    required String id,
    required String estado,
  }) => ReservationSummary(
    id: id,
    eventoId: 'event-1',
    estado: estado,
    cantidadEntradas: 2,
    total: 170000,
    eventoTitulo: 'Festival de Rock',
    eventoImagenUrl: 'https://example.com/event.jpg',
    eventoFecha: DateTime(2026, 3, 5),
    eventoCiudad: 'Bogotá',
  );

  setUp(() {
    getMyReservations = MockGetMyReservations();
  });

  Finder sectionHeader(String text) => find.byWidgetPredicate(
    (Widget w) =>
        w is Text && w.data == text && w.style == AppTypography.titleSmall,
  );

  Future<void> pumpReservations(WidgetTester tester) async {
    await pumpPage(
      tester,
      overrides: <Override>[
        getMyReservationsProvider.overrideWithValue(getMyReservations),
      ],
      child: const ReservationsPage(),
    );
    await tester.pumpAndSettle();
  }

  group('ReservationsPage', () {
    testWidgets(
      'shows the confirmadas and pendientes sections when both exist',
      (WidgetTester tester) async {
        when(getMyReservations.call).thenAnswer(
          (Invocation _) async => Success<List<ReservationSummary>>(
            <ReservationSummary>[
              buildSummary(id: 'res-1', estado: kReservationConfirmada),
              buildSummary(id: 'res-2', estado: kReservationPendiente),
            ],
          ),
        );

        await pumpReservations(tester);
        final AppLocalizations l10n = AppLocalizations.of(
          tester.element(find.byType(ReservationsPage)),
        );

        expect(
          sectionHeader(l10n.reservations_confirmed_section),
          findsOneWidget,
        );
        expect(
          sectionHeader(l10n.reservations_pending_section),
          findsOneWidget,
        );
      },
    );

    testWidgets('shows AppEmptyState when there are no reservations', (
      WidgetTester tester,
    ) async {
      when(getMyReservations.call).thenAnswer(
        (Invocation _) async =>
            const Success<List<ReservationSummary>>(<ReservationSummary>[]),
      );

      await pumpReservations(tester);

      expect(find.byType(AppEmptyState), findsOneWidget);
    });
  });
}
