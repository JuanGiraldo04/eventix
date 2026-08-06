import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/auth/di/auth_di.dart';
import 'package:eventix/features/auth/domain/usecases/register_user.dart';
import 'package:eventix/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart';

import '../../../../helpers/pump_page.dart';

class MockRegisterUser extends Mock implements RegisterUser {}

void main() {
  late MockRegisterUser registerUser;

  setUp(() {
    registerUser = MockRegisterUser();
  });

  group('RegisterPage', () {
    testWidgets(
      'renders the nombre, email and password fields and the register '
      'button',
      (WidgetTester tester) async {
        await pumpPage(
          tester,
          overrides: <Override>[
            registerUserProvider.overrideWithValue(registerUser),
          ],
          child: const RegisterPage(),
        );
        final AppLocalizations l10n = AppLocalizations.of(
          tester.element(find.byType(RegisterPage)),
        );

        expect(find.text(l10n.register_name_label), findsOneWidget);
        expect(find.text(l10n.login_email_label), findsOneWidget);
        expect(find.text(l10n.login_password_label), findsOneWidget);
        expect(
          find.text(testAppConfig.auth.registro.boton),
          findsOneWidget,
        );
      },
    );
  });
}
