import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/di/reservations_di.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_summary.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_reservations_provider.g.dart';

@riverpod
class MyReservationsNotifier extends _$MyReservationsNotifier {
  @override
  Future<List<ReservationSummary>> build() async {
    final Result<List<ReservationSummary>> result = await ref
        .watch(
          getMyReservationsProvider,
        )
        .call();
    return switch (result) {
      Success<List<ReservationSummary>>(:final List<ReservationSummary> data) =>
        data,
      FailureResult<List<ReservationSummary>>(:final Failure failure) =>
        throw failure,
    };
  }
}
