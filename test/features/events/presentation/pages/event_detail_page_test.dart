import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/events/di/events_di.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/domain/usecases/get_event_by_id.dart';
import 'package:eventix/features/events/presentation/pages/event_detail_page.dart';
import 'package:eventix/features/events/presentation/utils/event_formatters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart' show Override;

import '../../../../helpers/pump_page.dart';

class MockGetEventById extends Mock implements GetEventById {}

void main() {
  late MockGetEventById getEventById;

  Event buildEvent({required int cuposDisponibles}) => Event(
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
    cuposDisponibles: cuposDisponibles,
  );

  setUp(() {
    getEventById = MockGetEventById();
  });

  group('EventDetailPage', () {
    testWidgets('shows the event title and price', (
      WidgetTester tester,
    ) async {
      when(() => getEventById.call('event-1')).thenAnswer(
        (Invocation _) async =>
            Success<Event>(buildEvent(cuposDisponibles: 40)),
      );

      await pumpPage(
        tester,
        overrides: <Override>[
          getEventByIdProvider.overrideWithValue(getEventById),
        ],
        child: const EventDetailPage(eventId: 'event-1'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Festival de Rock'), findsOneWidget);
      expect(find.textContaining(formatEventPrecio(85000)), findsOneWidget);
    });

    testWidgets('the reserve button is enabled when there are spots left', (
      WidgetTester tester,
    ) async {
      when(() => getEventById.call('event-1')).thenAnswer(
        (Invocation _) async =>
            Success<Event>(buildEvent(cuposDisponibles: 40)),
      );

      await pumpPage(
        tester,
        overrides: <Override>[
          getEventByIdProvider.overrideWithValue(getEventById),
        ],
        child: const EventDetailPage(eventId: 'event-1'),
      );
      await tester.pumpAndSettle();
      final AppLocalizations l10n = AppLocalizations.of(
        tester.element(find.byType(EventDetailPage)),
      );

      expect(find.text(l10n.event_detail_reserve), findsOneWidget);
      final AppButton button = tester.widget<AppButton>(
        find.byType(AppButton),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('the reserve button is disabled when there are no spots left', (
      WidgetTester tester,
    ) async {
      when(() => getEventById.call('event-1')).thenAnswer(
        (Invocation _) async => Success<Event>(buildEvent(cuposDisponibles: 0)),
      );

      await pumpPage(
        tester,
        overrides: <Override>[
          getEventByIdProvider.overrideWithValue(getEventById),
        ],
        child: const EventDetailPage(eventId: 'event-1'),
      );
      await tester.pumpAndSettle();
      final AppLocalizations l10n = AppLocalizations.of(
        tester.element(find.byType(EventDetailPage)),
      );

      expect(find.text(l10n.event_detail_sold_out), findsOneWidget);
      final AppButton button = tester.widget<AppButton>(
        find.byType(AppButton),
      );
      expect(button.onPressed, isNull);
    });
  });
}
