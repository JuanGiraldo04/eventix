import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/domain/repositories/auth_repository.dart';
import 'package:eventix/features/auth/domain/usecases/login_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LoginUser usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = LoginUser(repository);
  });

  group('LoginUser', () {
    test(
      'given valid credentials '
      'when call is invoked '
      'then it calls AuthRepository.login with the same email and password',
      () async {
        const AppUser user = AppUser(
          id: 'user-1',
          email: 'juan@example.com',
          nombre: 'Juan',
        );
        when(
          () => repository.login(
            email: 'juan@example.com',
            password: 'secret123',
          ),
        ).thenAnswer((Invocation _) async => const Success<AppUser>(user));

        final Result<AppUser> result = await usecase.call(
          email: 'juan@example.com',
          password: 'secret123',
        );

        expect(result, isA<Success<AppUser>>());
        expect((result as Success<AppUser>).data, user);
        verify(
          () => repository.login(
            email: 'juan@example.com',
            password: 'secret123',
          ),
        ).called(1);
      },
    );

    test(
      'given the repository returns a failure '
      'when call is invoked '
      'then it returns the same failure unchanged',
      () async {
        when(
          () => repository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (Invocation _) async =>
              const FailureResult<AppUser>(UnauthorizedFailure()),
        );

        final Result<AppUser> result = await usecase.call(
          email: 'juan@example.com',
          password: 'wrong',
        );

        expect(result, isA<FailureResult<AppUser>>());
        expect(
          (result as FailureResult<AppUser>).failure,
          isA<UnauthorizedFailure>(),
        );
      },
    );
  });
}
