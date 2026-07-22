import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/di/auth_di.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/domain/usecases/register_user.dart';
import 'package:eventix/features/auth/presentation/providers/register_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart';

class MockRegisterUser extends Mock implements RegisterUser {}

void main() {
  late MockRegisterUser registerUser;
  late ProviderContainer container;

  setUp(() {
    registerUser = MockRegisterUser();
    container = ProviderContainer(
      overrides: <Override>[
        registerUserProvider.overrideWithValue(registerUser),
      ],
    );
    addTearDown(container.dispose);
    container.listen(
      registerProvider,
      (AsyncValue<AppUser?>? _, AsyncValue<AppUser?> _) {},
    );
  });

  group('RegisterNotifier', () {
    test(
      'given the notifier was just created '
      'when build runs '
      'then the initial state is AsyncData(null)',
      () {
        expect(
          container.read(registerProvider),
          const AsyncData<AppUser?>(null),
        );
      },
    );

    test(
      'given valid registration data '
      'when register is called '
      'then state goes to loading and then to data with the user',
      () async {
        const AppUser user = AppUser(
          id: 'user-1',
          email: 'juan@example.com',
          nombre: 'Juan',
        );
        when(
          () => registerUser.call(
            nombre: 'Juan',
            email: 'juan@example.com',
            password: 'secret123',
          ),
        ).thenAnswer((Invocation _) async => const Success<AppUser>(user));

        final Future<void> future = container
            .read(registerProvider.notifier)
            .register(
              nombre: 'Juan',
              email: 'juan@example.com',
              password: 'secret123',
            );

        expect(container.read(registerProvider).isLoading, isTrue);
        await future;

        expect(container.read(registerProvider).value, user);
      },
    );

    test(
      'given the email is already registered '
      'when register is called '
      'then state goes to error with the failure',
      () async {
        when(
          () => registerUser.call(
            nombre: any(named: 'nombre'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (Invocation _) async => const FailureResult<AppUser>(ServerFailure()),
        );

        await container
            .read(registerProvider.notifier)
            .register(
              nombre: 'Juan',
              email: 'juan@example.com',
              password: 'secret123',
            );

        final AsyncValue<AppUser?> state = container.read(registerProvider);
        expect(state.hasError, isTrue);
        expect(state.error, isA<ServerFailure>());
      },
    );
  });
}
