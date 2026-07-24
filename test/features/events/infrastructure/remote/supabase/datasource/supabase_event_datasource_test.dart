import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/features/events/domain/entities/event_filter.dart';
import 'package:eventix/features/events/infrastructure/remote/supabase/datasource/supabase_event_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// See supabase_auth_datasource_test.dart for why this exercises a real
// SupabaseClient against an unreachable host instead of mocking the SDK's
// query-builder chain.
void main() {
  SupabaseEventDatasource buildDatasource() => SupabaseEventDatasource(
    SupabaseClient('https://invalid.invalid.test', 'anon-key'),
  );

  group('SupabaseEventDatasource.getEvents', () {
    test(
      'given the events endpoint is unreachable and no filter '
      'when getEvents is called '
      'then it throws a Failure mapped from the network error',
      () async {
        final SupabaseEventDatasource datasource = buildDatasource();

        await expectLater(datasource.getEvents(), throwsA(isA<Failure>()));
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test(
      'given the events endpoint is unreachable '
      'when getEvents is called with every filter field set '
      'then it still throws a Failure after building the full query',
      () async {
        final SupabaseEventDatasource datasource = buildDatasource();

        await expectLater(
          datasource.getEvents(
            filter: EventFilter(
              query: 'maratón',
              categoria: 'Atletismo',
              ciudad: 'Bogotá',
              fecha: DateTime(2026, 3, 5),
            ),
          ),
          throwsA(isA<Failure>()),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  group('SupabaseEventDatasource.getEventById', () {
    test(
      'given the events endpoint is unreachable '
      'when getEventById is called '
      'then it throws a Failure mapped from the network error',
      () async {
        final SupabaseEventDatasource datasource = buildDatasource();

        await expectLater(
          datasource.getEventById('event-1'),
          throwsA(isA<Failure>()),
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
