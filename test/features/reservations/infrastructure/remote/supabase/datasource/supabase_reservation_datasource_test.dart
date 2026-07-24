import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/datasource/supabase_reservation_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// See supabase_auth_datasource_test.dart for why this exercises a real
// SupabaseClient against an unreachable host instead of mocking the SDK's
// query-builder chain.
void main() {
  SupabaseReservationDatasource buildDatasource() =>
      SupabaseReservationDatasource(
        SupabaseClient('https://invalid.invalid.test', 'anon-key'),
      );

  group('SupabaseReservationDatasource.createReservation', () {
    test(
      'given a client with no active session '
      'when createReservation is called '
      'then it throws UnauthorizedFailure without making a network call',
      () async {
        final SupabaseReservationDatasource datasource = buildDatasource();

        await expectLater(
          datasource.createReservation(
            eventoId: 'event-1',
            cantidadEntradas: 1,
            total: 85000,
          ),
          throwsA(isA<UnauthorizedFailure>()),
        );
      },
    );
  });

  group('SupabaseReservationDatasource.updateReservationQuantity', () {
    test(
      'given the reservations endpoint is unreachable '
      'when updateReservationQuantity is called '
      'then it throws a Failure mapped from the network error',
      () async {
        final SupabaseReservationDatasource datasource = buildDatasource();

        await expectLater(
          datasource.updateReservationQuantity(
            reservationId: 'res-1',
            cantidadEntradas: 2,
            total: 170000,
          ),
          throwsA(isA<Failure>()),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  group('SupabaseReservationDatasource.confirmReservation', () {
    test(
      'given the RPC endpoint is unreachable '
      'when confirmReservation is called '
      'then it throws a Failure mapped from the network error',
      () async {
        final SupabaseReservationDatasource datasource = buildDatasource();

        await expectLater(
          datasource.confirmReservation('res-1'),
          throwsA(isA<Failure>()),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  group('SupabaseReservationDatasource.getMyReservations', () {
    test(
      'given the reservations endpoint is unreachable '
      'when getMyReservations is called '
      'then it throws a Failure mapped from the network error',
      () async {
        final SupabaseReservationDatasource datasource = buildDatasource();

        await expectLater(
          datasource.getMyReservations(),
          throwsA(isA<Failure>()),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  group('SupabaseReservationDatasource.getReservationById', () {
    test(
      'given the reservations endpoint is unreachable '
      'when getReservationById is called '
      'then it throws a Failure mapped from the network error',
      () async {
        final SupabaseReservationDatasource datasource = buildDatasource();

        await expectLater(
          datasource.getReservationById('res-1'),
          throwsA(isA<Failure>()),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
