import 'dart:io';

import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/errors/supabase_error_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('mapSupabaseError', () {
    test(
      'given an AuthException with an invalid login credentials message '
      'when mapSupabaseError is called '
      'then returns UnauthorizedFailure',
      () {
        final Failure failure = mapSupabaseError(
          const AuthException('Invalid login credentials'),
        );

        expect(failure, isA<UnauthorizedFailure>());
      },
    );

    test(
      'given an AuthException reporting the email is already registered '
      'when mapSupabaseError is called '
      'then returns ServerFailure',
      () {
        final Failure failure = mapSupabaseError(
          const AuthException('User already registered'),
        );

        expect(failure, isA<ServerFailure>());
      },
    );

    test(
      'given an AuthException reporting the account already exists '
      'when mapSupabaseError is called '
      'then returns ServerFailure',
      () {
        final Failure failure = mapSupabaseError(
          const AuthException('Account already exists'),
        );

        expect(failure, isA<ServerFailure>());
      },
    );

    test(
      'given an AuthException with an unmapped message '
      'when mapSupabaseError is called '
      'then returns ServerFailure with the original message',
      () {
        final Failure failure = mapSupabaseError(
          const AuthException('Something went wrong'),
        );

        expect(failure, isA<ServerFailure>());
        expect(failure.userMessage, 'Something went wrong');
      },
    );

    test(
      'given a PostgrestException with code PGRST116 '
      'when mapSupabaseError is called '
      'then returns NotFoundFailure',
      () {
        final Failure failure = mapSupabaseError(
          const PostgrestException(message: 'no rows found', code: 'PGRST116'),
        );

        expect(failure, isA<NotFoundFailure>());
      },
    );

    test(
      'given a PostgrestException with a different code '
      'when mapSupabaseError is called '
      'then returns ServerFailure with the original message',
      () {
        final Failure failure = mapSupabaseError(
          const PostgrestException(
            message: 'constraint violated',
            code: '23505',
          ),
        );

        expect(failure, isA<ServerFailure>());
        expect(failure.userMessage, 'constraint violated');
      },
    );

    test(
      'given a SocketException when mapSupabaseError is called '
      'then returns ConnectionFailure',
      () {
        final Failure failure = mapSupabaseError(
          const SocketException('Failed host lookup'),
        );

        expect(failure, isA<ConnectionFailure>());
      },
    );

    test(
      'given an unmapped error type when mapSupabaseError is called '
      'then returns UnexpectedFailure',
      () {
        final Failure failure = mapSupabaseError(Exception('boom'));

        expect(failure, isA<UnexpectedFailure>());
      },
    );
  });
}
