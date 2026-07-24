// Integration tests against the real Supabase project configured in .env.
//
// These 4 flows run as ONE continuous user journey rather than 4 isolated
// tests: Supabase's auth session and GoRouter's current location are real
// process-wide singletons that persist across `pumpWidget` calls within this
// test binary, so each flow intentionally continues where the previous one
// left off (register -> logout/login -> filter -> reserve). Riverpod state
// (filters, checkout quantity, etc.) resets every time because each test
// mounts a brand new ProviderScope.
//
// Run order matters — do not reorder these testWidgets blocks.
import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/env/env.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/core/router/routes.dart';
import 'package:eventix/features/events/presentation/widgets/event_card.dart';
import 'package:eventix/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration step = const Duration(milliseconds: 300),
  int maxTries = 100,
}) async {
  for (int i = 0; i < maxTries; i++) {
    if (condition()) return;
    await tester.pump(step);
  }
  throw TestFailure(
    'pumpUntil: condition not met after ${maxTries * step.inMilliseconds}ms',
  );
}

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int maxTries = 100,
}) => pumpUntil(tester, () => finder.evaluate().isNotEmpty, maxTries: maxTries);

AppLocalizations l10nOf(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(Scaffold).first));

// AppButton labels can collide with page titles that share the same
// translated string (e.g. "Crear cuenta" is both register_title and
// register_submit), so button taps are scoped to the AppButton widget
// instead of a bare text search.
Finder appButton(String label) => find.widgetWithText(AppButton, label);

Future<void> fillTextFields(WidgetTester tester, List<String> values) async {
  for (int i = 0; i < values.length; i++) {
    await tester.enterText(find.byType(TextField).at(i), values[i]);
  }
  await tester.pump();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final int runId = DateTime.now().microsecondsSinceEpoch;
  final String testUserEmail = 'eventix.qa+$runId@gmail.com';
  const String testUserName = 'QA Eventix';
  const String testUserPassword = 'Eventix123!';

  setUpAll(() async {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabasePublishableKey,
    );
  });

  group('Eventix critical user journeys', () {
    testWidgets(
      'Flow 1 - Registro: a new user can sign up and reach the events list',
      (WidgetTester tester) async {
        await tester.pumpWidget(const ProviderScope(child: MainApp()));
        await pumpUntilFound(tester, find.byType(LoginPage));

        final AppLocalizations l10n = l10nOf(tester);
        await tester.tap(find.text(l10n.login_go_register));
        await pumpUntilFound(tester, find.byType(RegisterPage));
        // Mid page-transition, LoginPage's 2 TextFields can still be mounted
        // alongside RegisterPage's 3 while the route animates out — filling
        // by index too early lands text on the wrong (soon-to-be-disposed)
        // fields. Wait until only RegisterPage's fields remain.
        await pumpUntil(
          tester,
          () => find.byType(TextField).evaluate().length == 3,
        );

        await fillTextFields(tester, <String>[
          testUserName,
          testUserEmail,
          testUserPassword,
        ]);
        await tester.tap(appButton(l10n.register_submit));
        await pumpUntilFound(tester, find.byType(EventsPage), maxTries: 200);

        expect(find.byType(EventsPage), findsOneWidget);
      },
    );

    testWidgets(
      'Flow 2 - Login: logging out and back in returns to the events list',
      (WidgetTester tester) async {
        await tester.pumpWidget(const ProviderScope(child: MainApp()));
        await pumpUntilFound(tester, find.byType(EventsPage));

        final AppLocalizations l10n = l10nOf(tester);

        await tester.tap(find.byType(AppAvatar));
        await pumpUntilFound(tester, find.byType(ProfilePage));

        await tester.tap(appButton(l10n.profile_logout));
        await pumpUntilFound(tester, find.byType(LoginPage), maxTries: 200);
        await pumpUntil(
          tester,
          () => find.byType(TextField).evaluate().length == 2,
          maxTries: 200,
        );

        await fillTextFields(tester, <String>[testUserEmail, testUserPassword]);
        await tester.tap(appButton(l10n.login_submit));
        await pumpUntilFound(tester, find.byType(EventsPage), maxTries: 200);

        expect(find.byType(EventsPage), findsOneWidget);
      },
    );

    testWidgets(
      'Flow 3 - Filtros: selecting a category only shows matching events',
      (WidgetTester tester) async {
        await tester.pumpWidget(const ProviderScope(child: MainApp()));
        await pumpUntilFound(tester, find.byType(EventsPage));
        await pumpUntil(
          tester,
          () => find.byType(AppLoader).evaluate().isEmpty,
        );

        const String categoria = 'Fútbol';
        final Finder categoryChip = find.byWidgetPredicate(
          (Widget w) => w is AppChip && w.label == categoria && !w.isSelected,
        );
        expect(categoryChip, findsOneWidget);

        await tester.tap(categoryChip);
        await tester.pump();
        await pumpUntil(
          tester,
          () => find.byType(AppLoader).evaluate().isEmpty,
          maxTries: 200,
        );

        final List<EventCard> cards = tester
            .widgetList<EventCard>(find.byType(EventCard))
            .toList();
        if (cards.isEmpty) {
          expect(find.byType(AppEmptyState), findsOneWidget);
        } else {
          for (final EventCard card in cards) {
            expect(card.event.categoria, categoria);
          }
        }
      },
    );

    testWidgets(
      'Flow 4 - Reserva completa: reserving an event flows through to '
      'Mis Reservas',
      (WidgetTester tester) async {
        await tester.pumpWidget(const ProviderScope(child: MainApp()));
        await pumpUntilFound(tester, find.byType(EventsPage));
        await pumpUntilFound(tester, find.byType(EventCard));

        final AppLocalizations l10n = l10nOf(tester);

        final List<EventCard> cards = tester
            .widgetList<EventCard>(find.byType(EventCard))
            .toList();
        final EventCard availableCard = cards.firstWhere(
          (EventCard c) => c.event.tieneCupos,
          orElse: () =>
              throw TestFailure('No available events found to reserve'),
        );
        final String eventTitle = availableCard.event.titulo;
        final int cardIndex = cards.indexOf(availableCard);

        await tester.tap(find.byType(EventCard).at(cardIndex));
        await pumpUntilFound(tester, find.byType(EventDetailPage));
        await pumpUntilFound(
          tester,
          find.text(l10n.event_detail_reserve),
          maxTries: 200,
        );

        await tester.tap(appButton(l10n.event_detail_reserve));
        await pumpUntilFound(
          tester,
          find.byType(CheckoutPage),
          maxTries: 200,
        );
        await pumpUntilFound(
          tester,
          find.text(l10n.checkout_confirm),
          maxTries: 200,
        );

        await tester.tap(appButton(l10n.checkout_confirm));
        await pumpUntilFound(
          tester,
          find.byType(ConfirmationPage),
          maxTries: 200,
        );
        // Waiting on `eventTitle` text here is unreliable: CheckoutPage (the
        // outgoing page) shows the same event title and can still be
        // mounted mid-transition, so the text can resolve before
        // ConfirmationPage's own async data — and its button — has actually
        // loaded. Wait on the button we're about to tap instead.
        await pumpUntilFound(
          tester,
          appButton(l10n.confirmation_view_reservations),
          maxTries: 200,
        );
        expect(find.textContaining(eventTitle), findsWidgets);

        await tester.tap(appButton(l10n.confirmation_view_reservations));
        await pumpUntilFound(tester, find.byType(ReservationsPage));
        await pumpUntilFound(
          tester,
          find.textContaining(eventTitle),
          maxTries: 200,
        );

        expect(find.textContaining(eventTitle), findsWidgets);
      },
    );
  });
}
