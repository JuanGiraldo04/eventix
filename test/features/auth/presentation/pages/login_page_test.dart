import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/auth/di/auth_di.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/domain/usecases/login_user.dart';
import 'package:eventix/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart';

import '../../../../helpers/pump_page.dart';

class MockLoginUser extends Mock implements LoginUser {}

void main() {
  late MockLoginUser loginUser;

  setUp(() {
    loginUser = MockLoginUser();
  });

  group('LoginPage', () {
    testWidgets('renders the email and password fields and the login button', (
      WidgetTester tester,
    ) async {
      await pumpPage(
        tester,
        overrides: <Override>[loginUserProvider.overrideWithValue(loginUser)],
        child: const LoginPage(),
      );
      final AppLocalizations l10n = AppLocalizations.of(
        tester.element(find.byType(LoginPage)),
      );

      expect(find.text(l10n.login_email_label), findsOneWidget);
      expect(find.text(l10n.login_password_label), findsOneWidget);
      expect(find.text(testAppConfig.auth.login.boton), findsOneWidget);
    });

    testWidgets(
      'shows the error banner when the login provider returns AsyncError',
      (WidgetTester tester) async {
        when(
          () => loginUser.call(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (Invocation _) async => const FailureResult<AppUser>(
            UnauthorizedFailure('Correo o clave incorrectos'),
          ),
        );

        await pumpPage(
          tester,
          overrides: <Override>[
            loginUserProvider.overrideWithValue(loginUser),
          ],
          child: const LoginPage(),
        );

        await tester.enterText(
          find.byType(TextField).at(0),
          'juan@example.com',
        );
        await tester.enterText(find.byType(TextField).at(1), 'wrong');
        await tester.tap(find.text(testAppConfig.auth.login.boton));
        await tester.pumpAndSettle();

        expect(find.text('Correo o clave incorrectos'), findsOneWidget);
      },
    );
  });
}
