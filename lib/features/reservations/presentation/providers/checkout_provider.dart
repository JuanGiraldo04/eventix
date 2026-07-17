import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/events/di/events_di.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/reservations/di/reservations_di.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'checkout_provider.g.dart';

class CheckoutData {
  const CheckoutData({required this.reservation, required this.event});

  final ReservationDetail reservation;
  final Event event;
}

@riverpod
class CheckoutNotifier extends _$CheckoutNotifier {
  @override
  Future<CheckoutData> build(String reservationId) async {
    final Result<ReservationDetail> reservationResult = await ref
        .watch(getReservationByIdProvider)
        .call(reservationId);
    final ReservationDetail reservation = switch (reservationResult) {
      Success<ReservationDetail>(:final ReservationDetail data) => data,
      FailureResult<ReservationDetail>(:final Failure failure) => throw failure,
    };

    final Result<Event> eventResult = await ref
        .watch(getEventByIdProvider)
        .call(reservation.eventoId);
    final Event event = switch (eventResult) {
      Success<Event>(:final Event data) => data,
      FailureResult<Event>(:final Failure failure) => throw failure,
    };

    return CheckoutData(reservation: reservation, event: event);
  }
}
