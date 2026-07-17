import 'dart:async';

import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/di/reservations_di.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'confirm_purchase_provider.g.dart';

@riverpod
class ConfirmPurchaseNotifier extends _$ConfirmPurchaseNotifier {
  @override
  FutureOr<Reservation?> build() => null;

  Future<void> confirmPurchase({
    required String reservationId,
    required int cantidadEntradas,
    required double total,
  }) async {
    state = const AsyncLoading<Reservation?>();

    final Result<Reservation> updateResult = await ref
        .read(updateReservationQuantityProvider)
        .call(
          reservationId: reservationId,
          cantidadEntradas: cantidadEntradas,
          total: total,
        );
    if (!ref.mounted) return;
    if (updateResult is FailureResult<Reservation>) {
      state = AsyncError<Reservation?>(
        updateResult.failure,
        StackTrace.current,
      );
      return;
    }

    final Result<Reservation> confirmResult = await ref
        .read(confirmReservationProvider)
        .call(reservationId);
    if (!ref.mounted) return;
    state = switch (confirmResult) {
      Success<Reservation>(:final Reservation data) => AsyncData<Reservation?>(
        data,
      ),
      FailureResult<Reservation>(:final Failure failure) =>
        AsyncError<Reservation?>(
          failure,
          StackTrace.current,
        ),
    };
  }
}
