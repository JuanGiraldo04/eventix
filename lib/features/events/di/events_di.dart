import 'package:eventix/core/services/supabase/supabase_provider.dart';
import 'package:eventix/features/events/domain/usecases/get_event_by_id.dart';
import 'package:eventix/features/events/domain/usecases/get_events.dart';
import 'package:eventix/features/events/infrastructure/remote/supabase/datasource/supabase_event_datasource.dart';
import 'package:eventix/features/events/infrastructure/repositories/event_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'events_di.g.dart';

@riverpod
SupabaseEventDatasource eventRemoteDatasource(Ref ref) =>
    SupabaseEventDatasource(ref.watch(supabaseClientProvider));

@riverpod
EventRepositoryImpl eventRepository(Ref ref) =>
    EventRepositoryImpl(ref.watch(eventRemoteDatasourceProvider));

@riverpod
GetEvents getEvents(Ref ref) => GetEvents(ref.watch(eventRepositoryProvider));

@riverpod
GetEventById getEventById(Ref ref) =>
    GetEventById(ref.watch(eventRepositoryProvider));
