import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/di/reservations_di.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reservation_detail_provider.g.dart';

@riverpod
class ReservationDetailNotifier extends _$ReservationDetailNotifier {
  @override
  Future<ReservationDetail> build(String reservationId) async {
    final Result<ReservationDetail> result = await ref
        .watch(getReservationByIdProvider)
        .call(reservationId);
    return switch (result) {
      Success<ReservationDetail>(:final ReservationDetail data) => data,
      FailureResult<ReservationDetail>(:final Failure failure) => throw failure,
    };
  }
}
