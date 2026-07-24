import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/features/auth/infrastructure/remote/supabase/datasource/supabase_auth_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// These datasources wrap the Supabase SDK's own fluent query builders
// (PostgrestFilterBuilder, GoTrueClient, etc.), which are concrete classes
// rather than small interfaces — mocking their full chain would be brittle
// scaffolding around the SDK's internals rather than a real correctness
// check (see docs/integration-testing.md). Instead these tests exercise the
// datasource against a real SupabaseClient pointed at an unreachable host,
// which deterministically fails at the network step and lets us verify the
// try/catch -> mapSupabaseError() wiring with real (not mocked) exceptions.
void main() {
  SupabaseAuthDatasource buildDatasource() => SupabaseAuthDatasource(
    SupabaseClient('https://invalid.invalid.test', 'anon-key'),
  );

  group('SupabaseAuthDatasource.getCurrentUser', () {
    test(
      'given a client with no active session '
      'when getCurrentUser is called '
      'then it throws UnexpectedFailure without making a network call',
      () async {
        final SupabaseAuthDatasource datasource = buildDatasource();

        await expectLater(
          datasource.getCurrentUser(),
          throwsA(isA<UnexpectedFailure>()),
        );
      },
    );
  });

  group('SupabaseAuthDatasource.login', () {
    test(
      'given the auth endpoint is unreachable '
      'when login is called '
      'then it throws a Failure mapped from the network error',
      () async {
        final SupabaseAuthDatasource datasource = buildDatasource();

        await expectLater(
          datasource.login(email: 'juan@example.com', password: 'secret'),
          throwsA(isA<Failure>()),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  group('SupabaseAuthDatasource.register', () {
    test(
      'given the auth endpoint is unreachable '
      'when register is called '
      'then it throws a Failure mapped from the network error',
      () async {
        final SupabaseAuthDatasource datasource = buildDatasource();

        await expectLater(
          datasource.register(
            nombre: 'Juan',
            email: 'juan@example.com',
            password: 'secret',
          ),
          throwsA(isA<Failure>()),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  group('SupabaseAuthDatasource.logout', () {
    test(
      'given a client with no active session (the SDK skips the network '
      'call entirely) '
      'when logout is called '
      'then it completes without throwing',
      () async {
        final SupabaseAuthDatasource datasource = buildDatasource();

        await expectLater(datasource.logout(), completes);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
