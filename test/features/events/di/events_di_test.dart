import 'package:eventix/core/services/supabase/supabase_provider.dart';
import 'package:eventix/features/events/di/events_di.dart';
import 'package:eventix/features/events/domain/usecases/get_event_by_id.dart';
import 'package:eventix/features/events/domain/usecases/get_events.dart';
import 'package:eventix/features/events/infrastructure/remote/supabase/datasource/supabase_event_datasource.dart';
import 'package:eventix/features/events/infrastructure/repositories/event_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/src/framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test(
    'given a SupabaseClient override '
    'when the events DI providers are read '
    'then each one resolves the expected concrete type',
    () {
      final SupabaseClient client = SupabaseClient(
        'https://example.supabase.co',
        'anon-key',
      );
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          supabaseClientProvider.overrideWithValue(client),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(eventRemoteDatasourceProvider),
        isA<SupabaseEventDatasource>(),
      );
      expect(
        container.read(eventRepositoryProvider),
        isA<EventRepositoryImpl>(),
      );
      expect(container.read(getEventsProvider), isA<GetEvents>());
      expect(container.read(getEventByIdProvider), isA<GetEventById>());
    },
  );
}
