import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/infrastructure/remote/remote_auth_datasource.dart';
import 'package:eventix/features/auth/infrastructure/remote/supabase/models/remote_user_model.dart';
import 'package:eventix/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

RemoteUserModel _tRemoteUser() => const RemoteUserModel(
  id: 'user-1',
  email: 'juan@example.com',
  nombre: 'Juan',
);

void main() {
  late MockAuthRemoteDatasource remoteDatasource;
  late AuthRepositoryImpl repository;

  setUp(() {
    remoteDatasource = MockAuthRemoteDatasource();
    repository = AuthRepositoryImpl(remoteDatasource);
  });

  group('AuthRepositoryImpl.login', () {
    test(
      'given the remote datasource returns a user '
      'when login is called '
      'then it calls the datasource with the same credentials '
      'and returns the mapped entity',
      () async {
        when(
          () => remoteDatasource.login(
            email: 'juan@example.com',
            password: 'secret',
          ),
        ).thenAnswer((Invocation _) async => _tRemoteUser());

        final Result<AppUser> result = await repository.login(
          email: 'juan@example.com',
          password: 'secret',
        );

        expect(result, isA<Success<AppUser>>());
        expect((result as Success<AppUser>).data.id, 'user-1');
        verify(
          () => remoteDatasource.login(
            email: 'juan@example.com',
            password: 'secret',
          ),
        ).called(1);
      },
    );

    test(
      'given the remote datasource throws UnauthorizedFailure '
      'when login is called '
      'then it returns FailureResult with the same failure',
      () async {
        when(
          () => remoteDatasource.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const UnauthorizedFailure('Correo o clave incorrectos'));

        final Result<AppUser> result = await repository.login(
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

  group('AuthRepositoryImpl.register', () {
    test(
      'given the remote datasource returns a user '
      'when register is called '
      'then it calls the datasource with the same params '
      'and returns the mapped entity',
      () async {
        when(
          () => remoteDatasource.register(
            nombre: 'Juan',
            email: 'juan@example.com',
            password: 'secret',
          ),
        ).thenAnswer((Invocation _) async => _tRemoteUser());

        final Result<AppUser> result = await repository.register(
          nombre: 'Juan',
          email: 'juan@example.com',
          password: 'secret',
        );

        expect(result, isA<Success<AppUser>>());
        expect((result as Success<AppUser>).data.nombre, 'Juan');
      },
    );

    test(
      'given the remote datasource throws a ServerFailure '
      'when register is called '
      'then it returns FailureResult with the same failure',
      () async {
        when(
          () => remoteDatasource.register(
            nombre: any(named: 'nombre'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          const ServerFailure('Ya existe una cuenta con este correo'),
        );

        final Result<AppUser> result = await repository.register(
          nombre: 'Juan',
          email: 'juan@example.com',
          password: 'secret',
        );

        expect(result, isA<FailureResult<AppUser>>());
        expect(
          (result as FailureResult<AppUser>).failure,
          isA<ServerFailure>(),
        );
      },
    );
  });

  group('AuthRepositoryImpl.logout', () {
    test(
      'given the remote datasource logs out successfully '
      'when logout is called '
      'then it returns Success',
      () async {
        when(remoteDatasource.logout).thenAnswer((Invocation _) async {});

        final Result<void> result = await repository.logout();

        expect(result, isA<Success<void>>());
        verify(remoteDatasource.logout).called(1);
      },
    );

    test(
      'given the remote datasource throws ConnectionFailure '
      'when logout is called '
      'then it returns FailureResult with the same failure',
      () async {
        when(remoteDatasource.logout).thenThrow(const ConnectionFailure());

        final Result<void> result = await repository.logout();

        expect(result, isA<FailureResult<void>>());
        expect(
          (result as FailureResult<void>).failure,
          isA<ConnectionFailure>(),
        );
      },
    );
  });

  group('AuthRepositoryImpl.getCurrentUser', () {
    test(
      'given the remote datasource returns a user '
      'when getCurrentUser is called '
      'then it returns the mapped entity',
      () async {
        when(
          remoteDatasource.getCurrentUser,
        ).thenAnswer((Invocation _) async => _tRemoteUser());

        final Result<AppUser> result = await repository.getCurrentUser();

        expect(result, isA<Success<AppUser>>());
        expect((result as Success<AppUser>).data.email, 'juan@example.com');
      },
    );

    test(
      'given the remote datasource throws UnauthorizedFailure '
      'when getCurrentUser is called '
      'then it returns FailureResult with the same failure',
      () async {
        when(
          remoteDatasource.getCurrentUser,
        ).thenThrow(const UnauthorizedFailure());

        final Result<AppUser> result = await repository.getCurrentUser();

        expect(result, isA<FailureResult<AppUser>>());
        expect(
          (result as FailureResult<AppUser>).failure,
          isA<UnauthorizedFailure>(),
        );
      },
    );
  });
}
