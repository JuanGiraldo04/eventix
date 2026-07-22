import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/domain/repositories/auth_repository.dart';
import 'package:eventix/features/auth/domain/usecases/get_current_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late GetCurrentUser usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = GetCurrentUser(repository);
  });

  group('GetCurrentUser', () {
    test(
      'given there is an active session '
      'when call is invoked '
      'then it calls AuthRepository.getCurrentUser and returns the user',
      () async {
        const AppUser user = AppUser(
          id: 'user-1',
          email: 'juan@example.com',
          nombre: 'Juan',
        );
        when(
          repository.getCurrentUser,
        ).thenAnswer((Invocation _) async => const Success<AppUser>(user));

        final Result<AppUser> result = await usecase.call();

        expect(result, isA<Success<AppUser>>());
        expect((result as Success<AppUser>).data, user);
        verify(repository.getCurrentUser).called(1);
      },
    );

    test(
      'given there is no active session '
      'when call is invoked '
      'then it returns the same failure unchanged',
      () async {
        when(repository.getCurrentUser).thenAnswer(
          (Invocation _) async =>
              const FailureResult<AppUser>(UnauthorizedFailure()),
        );

        final Result<AppUser> result = await usecase.call();

        expect(result, isA<FailureResult<AppUser>>());
        expect(
          (result as FailureResult<AppUser>).failure,
          isA<UnauthorizedFailure>(),
        );
      },
    );
  });
}
