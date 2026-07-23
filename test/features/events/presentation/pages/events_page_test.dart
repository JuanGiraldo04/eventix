import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/di/auth_di.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/domain/usecases/get_current_user.dart';
import 'package:eventix/features/events/di/events_di.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/domain/usecases/get_events.dart';
import 'package:eventix/features/events/presentation/pages/events_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart' show Override;

import '../../../../helpers/pump_page.dart';

class MockGetEvents extends Mock implements GetEvents {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

void main() {
  late MockGetEvents getEvents;
  late MockGetCurrentUser getCurrentUser;

  Event buildEvent(String id) => Event(
    id: id,
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

  List<Override> overridesWith(MockGetEvents mock) => <Override>[
    getEventsProvider.overrideWithValue(mock),
    getCurrentUserProvider.overrideWithValue(getCurrentUser),
  ];

  setUp(() {
    getEvents = MockGetEvents();
    getCurrentUser = MockGetCurrentUser();
    when(getCurrentUser.call).thenAnswer(
      (Invocation _) async => const Success<AppUser>(
        AppUser(id: 'user-1', email: 'juan@example.com', nombre: 'Juan'),
      ),
    );
  });

  group('EventsPage', () {
    testWidgets('shows AppLoader while events are loading', (
      WidgetTester tester,
    ) async {
      final Completer<Result<List<Event>>> completer =
          Completer<Result<List<Event>>>();
      when(
        () => getEvents.call(filter: any(named: 'filter')),
      ).thenAnswer((Invocation _) => completer.future);

      await pumpPage(
        tester,
        overrides: overridesWith(getEvents),
        child: const EventsPage(),
      );

      expect(find.byType(AppLoader), findsWidgets);
    });

    testWidgets('shows the event list when data is loaded', (
      WidgetTester tester,
    ) async {
      final Event event = buildEvent('event-1');
      when(() => getEvents.call(filter: any(named: 'filter'))).thenAnswer(
        (Invocation _) async => Success<List<Event>>(<Event>[event]),
      );

      await pumpPage(
        tester,
        overrides: overridesWith(getEvents),
        child: const EventsPage(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Festival de Rock'), findsOneWidget);
    });

    testWidgets('shows AppEmptyState when the event list is empty', (
      WidgetTester tester,
    ) async {
      when(() => getEvents.call(filter: any(named: 'filter'))).thenAnswer(
        (Invocation _) async => const Success<List<Event>>(<Event>[]),
      );

      await pumpPage(
        tester,
        overrides: overridesWith(getEvents),
        child: const EventsPage(),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppEmptyState), findsOneWidget);
    });

    testWidgets('shows AppErrorState when the events provider fails', (
      WidgetTester tester,
    ) async {
      when(() => getEvents.call(filter: any(named: 'filter'))).thenAnswer(
        (Invocation _) async =>
            const FailureResult<List<Event>>(ConnectionFailure()),
      );

      await pumpPage(
        tester,
        overrides: overridesWith(getEvents),
        child: const EventsPage(),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorState), findsOneWidget);
    });
  });
}
