import 'package:eventix/features/events/domain/entities/event_filter.dart';
import 'package:eventix/features/events/infrastructure/remote/supabase/models/remote_event_model.dart';

abstract interface class EventRemoteDatasource {
  Future<List<RemoteEventModel>> getEvents({EventFilter? filter});

  Future<RemoteEventModel> getEventById(String id);
}
