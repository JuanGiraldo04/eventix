import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/domain/repositories/auth_repository.dart';
import 'package:eventix/features/auth/domain/usecases/register_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late RegisterUser usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = RegisterUser(repository);
  });

  group('RegisterUser', () {
    test(
      'given valid registration data '
      'when call is invoked '
      'then it calls AuthRepository.register with the same nombre, email '
      'and password',
      () async {
        const AppUser user = AppUser(
          id: 'user-1',
          email: 'juan@example.com',
          nombre: 'Juan',
        );
        when(
          () => repository.register(
            nombre: 'Juan',
            email: 'juan@example.com',
            password: 'secret123',
          ),
        ).thenAnswer((Invocation _) async => const Success<AppUser>(user));

        final Result<AppUser> result = await usecase.call(
          nombre: 'Juan',
          email: 'juan@example.com',
          password: 'secret123',
        );

        expect(result, isA<Success<AppUser>>());
        expect((result as Success<AppUser>).data, user);
        verify(
          () => repository.register(
            nombre: 'Juan',
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
          () => repository.register(
            nombre: any(named: 'nombre'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (Invocation _) async => const FailureResult<AppUser>(ServerFailure()),
        );

        final Result<AppUser> result = await usecase.call(
          nombre: 'Juan',
          email: 'juan@example.com',
          password: 'secret123',
        );

        expect(result, isA<FailureResult<AppUser>>());
        expect(
          (result as FailureResult<AppUser>).failure,
          isA<ServerFailure>(),
        );
      },
    );
  });
}
