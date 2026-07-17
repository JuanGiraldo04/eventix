import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_summary.dart';

abstract interface class ReservationRepository {
  Future<Result<Reservation>> createReservation({
    required String eventoId,
    required int cantidadEntradas,
    required double total,
  });

  Future<Result<Reservation>> updateReservationQuantity({
    required String reservationId,
    required int cantidadEntradas,
    required double total,
  });

  Future<Result<Reservation>> confirmReservation(String reservationId);

  Future<Result<List<ReservationSummary>>> getMyReservations();

  Future<Result<ReservationDetail>> getReservationById(String reservationId);
}
