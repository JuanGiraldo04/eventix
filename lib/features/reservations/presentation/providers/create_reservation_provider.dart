import 'dart:async';

import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/di/reservations_di.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_reservation_provider.g.dart';

@riverpod
class ReservationCreationNotifier extends _$ReservationCreationNotifier {
  @override
  FutureOr<Reservation?> build() => null;

  Future<void> create({
    required String eventoId,
    required int cantidadEntradas,
    required double total,
  }) async {
    state = const AsyncLoading<Reservation?>();
    final Result<Reservation> result = await ref
        .read(createReservationProvider)
        .call(
          eventoId: eventoId,
          cantidadEntradas: cantidadEntradas,
          total: total,
        );
    if (!ref.mounted) return;
    state = switch (result) {
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
