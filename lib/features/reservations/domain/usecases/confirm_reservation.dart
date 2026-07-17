import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/domain/repositories/reservation_repository.dart';

class ConfirmReservation {
  const ConfirmReservation(this._repository);

  final ReservationRepository _repository;

  Future<Result<Reservation>> call(String reservationId) =>
      _repository.confirmReservation(reservationId);
}
