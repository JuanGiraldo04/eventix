import 'package:eventix/core/helpers/execute_repository_call.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/domain/entities/event_filter.dart';
import 'package:eventix/features/events/domain/repositories/event_repository.dart';
import 'package:eventix/features/events/infrastructure/remote/remote_event_datasource.dart';
import 'package:eventix/features/events/infrastructure/remote/supabase/mappers/remote_event_mapper.dart';
import 'package:eventix/features/events/infrastructure/remote/supabase/models/remote_event_model.dart';

class EventRepositoryImpl implements EventRepository {
  const EventRepositoryImpl(this._remoteDatasource);

  final EventRemoteDatasource _remoteDatasource;

  @override
  Future<Result<List<Event>>> getEvents({EventFilter? filter}) {
    return executeRepositoryCall(() async {
      final List<RemoteEventModel> models = await _remoteDatasource.getEvents(
        filter: filter,
      );
      return RemoteEventMapper.toEntities(models);
    });
  }

  @override
  Future<Result<Event>> getEventById(String id) {
    return executeRepositoryCall(() async {
      final RemoteEventModel model = await _remoteDatasource.getEventById(id);
      return RemoteEventMapper.toEntity(model);
    });
  }
}
