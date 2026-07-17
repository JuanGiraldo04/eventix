import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/events/di/events_di.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_detail_provider.g.dart';

@riverpod
class EventDetailNotifier extends _$EventDetailNotifier {
  @override
  Future<Event> build(String eventId) async {
    final Result<Event> result = await ref
        .watch(getEventByIdProvider)
        .call(eventId);
    return switch (result) {
      Success<Event>(:final Event data) => data,
      FailureResult<Event>(:final Failure failure) => throw failure,
    };
  }
}
