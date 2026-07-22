import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/di/auth_di.dart';
import 'package:eventix/features/auth/domain/usecases/logout_user.dart';
import 'package:eventix/features/auth/presentation/providers/logout_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart';

class MockLogoutUser extends Mock implements LogoutUser {}

void main() {
  late MockLogoutUser logoutUser;
  late ProviderContainer container;

  setUp(() {
    logoutUser = MockLogoutUser();
    container = ProviderContainer(
      overrides: <Override>[logoutUserProvider.overrideWithValue(logoutUser)],
    );
    addTearDown(container.dispose);
    container.listen(
      logoutProvider,
      (AsyncValue<void>? _, AsyncValue<void> _) {},
    );
  });

  group('LogoutNotifier', () {
    test(
      'given the session ends successfully '
      'when logout is called '
      'then state goes to loading and then to data',
      () async {
        when(
          logoutUser.call,
        ).thenAnswer((Invocation _) async => const Success<void>(null));

        final Future<void> future = container
            .read(logoutProvider.notifier)
            .logout();

        expect(container.read(logoutProvider).isLoading, isTrue);
        await future;

        expect(container.read(logoutProvider).hasValue, isTrue);
      },
    );

    test(
      'given the repository fails to end the session '
      'when logout is called '
      'then state goes to error with the failure',
      () async {
        when(logoutUser.call).thenAnswer(
          (Invocation _) async =>
              const FailureResult<void>(ConnectionFailure()),
        );

        await container.read(logoutProvider.notifier).logout();

        final AsyncValue<void> state = container.read(logoutProvider);
        expect(state.hasError, isTrue);
        expect(state.error, isA<ConnectionFailure>());
      },
    );
  });
}
