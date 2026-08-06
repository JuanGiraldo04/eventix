import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/config/app_config_provider.dart';
import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/auth/di/auth_di.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/domain/usecases/get_current_user.dart';
import 'package:eventix/features/auth/domain/usecases/logout_user.dart';
import 'package:eventix/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart' show Override;

import '../../../../helpers/pump_page.dart';

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockLogoutUser extends Mock implements LogoutUser {}

void main() {
  late MockGetCurrentUser getCurrentUser;
  late MockLogoutUser logoutUser;

  setUp(() {
    getCurrentUser = MockGetCurrentUser();
    logoutUser = MockLogoutUser();
    when(getCurrentUser.call).thenAnswer(
      (Invocation _) async => const Success<AppUser>(
        AppUser(id: 'user-1', email: 'juan@example.com', nombre: 'Juan'),
      ),
    );
  });

  Future<void> pumpProfile(WidgetTester tester) async {
    await pumpPage(
      tester,
      overrides: <Override>[
        getCurrentUserProvider.overrideWithValue(getCurrentUser),
        logoutUserProvider.overrideWithValue(logoutUser),
      ],
      child: const ProfilePage(),
    );
    await tester.pumpAndSettle();
  }

  group('ProfilePage', () {
    testWidgets('shows the current user name and email', (
      WidgetTester tester,
    ) async {
      await pumpProfile(tester);

      expect(find.text('Juan'), findsOneWidget);
      expect(find.text('juan@example.com'), findsOneWidget);
    });

    testWidgets('shows the logout button', (WidgetTester tester) async {
      await pumpProfile(tester);
      final AppLocalizations l10n = AppLocalizations.of(
        tester.element(find.byType(ProfilePage)),
      );

      expect(find.text(l10n.profile_logout), findsOneWidget);
    });

    testWidgets('shows an AppBanner when logout fails', (
      WidgetTester tester,
    ) async {
      when(
        logoutUser.call,
      ).thenAnswer(
        (Invocation _) async => const FailureResult<void>(ConnectionFailure()),
      );

      await pumpProfile(tester);
      final AppLocalizations l10n = AppLocalizations.of(
        tester.element(find.byType(ProfilePage)),
      );

      await tester.tap(find.text(l10n.profile_logout));
      await tester.pumpAndSettle();

      expect(find.byType(AppBanner), findsOneWidget);
    });

    testWidgets('shows a tooltip on the config toggle button', (
      WidgetTester tester,
    ) async {
      await pumpProfile(tester);
      final AppLocalizations l10n = AppLocalizations.of(
        tester.element(find.byType(ProfilePage)),
      );

      expect(
        find.byTooltip(l10n.profile_toggle_config_tooltip),
        findsOneWidget,
      );
    });

    testWidgets('tapping the toggle switches the active config path', (
      WidgetTester tester,
    ) async {
      await pumpProfile(tester);
      final ProviderContainer container = ProviderScope.containerOf(
        tester.element(find.byType(ProfilePage)),
        listen: false,
      );

      final ProviderSubscription<String> sub = container.listen<String>(
        activeConfigPathProvider,
        (String? _, String _) {},
      );
      addTearDown(sub.close);
      final String pathBefore = container.read(activeConfigPathProvider);

      await tester.tap(find.byIcon(Icons.swap_horiz));
      await tester.pump();

      expect(container.read(activeConfigPathProvider), isNot(pathBefore));
    });
  });
}
