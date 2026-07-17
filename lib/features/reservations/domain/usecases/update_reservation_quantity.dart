import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/domain/repositories/reservation_repository.dart';

class UpdateReservationQuantity {
  const UpdateReservationQuantity(this._repository);

  final ReservationRepository _repository;

  Future<Result<Reservation>> call({
    required String reservationId,
    required int cantidadEntradas,
    required double total,
  }) => _repository.updateReservationQuantity(
    reservationId: reservationId,
    cantidadEntradas: cantidadEntradas,
    total: total,
  );
}
