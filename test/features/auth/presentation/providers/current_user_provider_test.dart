import 'dart:async';

import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/di/auth_di.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/domain/usecases/get_current_user.dart';
import 'package:eventix/features/auth/presentation/providers/current_user_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart';

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

void main() {
  late MockGetCurrentUser getCurrentUser;

  ProviderContainer buildContainer() {
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        getCurrentUserProvider.overrideWithValue(getCurrentUser),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    getCurrentUser = MockGetCurrentUser();
  });

  group('CurrentUserNotifier', () {
    test(
      'given Supabase has an active session '
      'when build runs '
      'then it returns the current user',
      () async {
        const AppUser user = AppUser(
          id: 'user-1',
          email: 'juan@example.com',
          nombre: 'Juan',
        );
        when(
          getCurrentUser.call,
        ).thenAnswer((Invocation _) async => const Success<AppUser>(user));

        final ProviderContainer container = buildContainer();
        // Mantiene vivo el AsyncNotifier autoDispose mientras se resuelve.
        container.listen(
          currentUserProvider,
          (AsyncValue<AppUser>? _, AsyncValue<AppUser> _) {},
        );

        final AppUser result = await container.read(
          currentUserProvider.future,
        );

        expect(result, user);
      },
    );

    test(
      'given there is no active session '
      'when build runs '
      'then the provider surfaces the failure as AsyncError',
      () async {
        when(getCurrentUser.call).thenAnswer(
          (Invocation _) async =>
              const FailureResult<AppUser>(UnauthorizedFailure()),
        );

        final ProviderContainer container = buildContainer();
        final Completer<Object> completer = Completer<Object>();
        container.listen(currentUserProvider, (
          AsyncValue<AppUser>? _,
          AsyncValue<AppUser> next,
        ) {
          if (next.hasError && !completer.isCompleted) {
            completer.complete(next.error);
          }
        });

        final Object error = await completer.future;

        expect(error, isA<UnauthorizedFailure>());
      },
    );
  });
}
