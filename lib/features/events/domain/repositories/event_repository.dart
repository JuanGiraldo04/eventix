import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/domain/entities/event_filter.dart';

abstract interface class EventRepository {
  Future<Result<List<Event>>> getEvents({EventFilter? filter});

  Future<Result<Event>> getEventById(String id);
}
