import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/domain/repositories/auth_repository.dart';
import 'package:eventix/features/auth/domain/usecases/logout_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LogoutUser usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = LogoutUser(repository);
  });

  group('LogoutUser', () {
    test(
      'given the repository logs out successfully '
      'when call is invoked '
      'then it calls AuthRepository.logout and returns a Success',
      () async {
        when(
          repository.logout,
        ).thenAnswer((Invocation _) async => const Success<void>(null));

        final Result<void> result = await usecase.call();

        expect(result, isA<Success<void>>());
        verify(repository.logout).called(1);
      },
    );

    test(
      'given the repository returns a failure '
      'when call is invoked '
      'then it returns the same failure unchanged',
      () async {
        when(repository.logout).thenAnswer(
          (Invocation _) async =>
              const FailureResult<void>(ConnectionFailure()),
        );

        final Result<void> result = await usecase.call();

        expect(result, isA<FailureResult<void>>());
        expect(
          (result as FailureResult<void>).failure,
          isA<ConnectionFailure>(),
        );
      },
    );
  });
}
