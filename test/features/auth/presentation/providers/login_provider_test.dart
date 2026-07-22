import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/di/auth_di.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/domain/usecases/login_user.dart';
import 'package:eventix/features/auth/presentation/providers/login_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart';

class MockLoginUser extends Mock implements LoginUser {}

void main() {
  late MockLoginUser loginUser;
  late ProviderContainer container;

  setUp(() {
    loginUser = MockLoginUser();
    container = ProviderContainer(
      overrides: <Override>[loginUserProvider.overrideWithValue(loginUser)],
    );
    addTearDown(container.dispose);
    // Mantiene vivo el AsyncNotifier autoDispose durante todo el test.
    container.listen(
      loginProvider,
      (AsyncValue<AppUser?>? _, AsyncValue<AppUser?> _) {},
    );
  });

  group('LoginNotifier', () {
    test(
      'given the notifier was just created '
      'when build runs '
      'then the initial state is AsyncData(null)',
      () {
        expect(container.read(loginProvider), const AsyncData<AppUser?>(null));
      },
    );

    test(
      'given valid credentials '
      'when login is called '
      'then state goes to loading and then to data with the user',
      () async {
        const AppUser user = AppUser(
          id: 'user-1',
          email: 'juan@example.com',
          nombre: 'Juan',
        );
        when(
          () => loginUser.call(
            email: 'juan@example.com',
            password: 'secret123',
          ),
        ).thenAnswer((Invocation _) async => const Success<AppUser>(user));

        final Future<void> future = container
            .read(loginProvider.notifier)
            .login(email: 'juan@example.com', password: 'secret123');

        expect(container.read(loginProvider).isLoading, isTrue);
        await future;

        expect(container.read(loginProvider).value, user);
      },
    );

    test(
      'given invalid credentials '
      'when login is called '
      'then state goes to error with the failure',
      () async {
        when(
          () => loginUser.call(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (Invocation _) async =>
              const FailureResult<AppUser>(UnauthorizedFailure()),
        );

        await container
            .read(loginProvider.notifier)
            .login(email: 'juan@example.com', password: 'wrong');

        final AsyncValue<AppUser?> state = container.read(loginProvider);
        expect(state.hasError, isTrue);
        expect(state.error, isA<UnauthorizedFailure>());
      },
    );
  });
}
