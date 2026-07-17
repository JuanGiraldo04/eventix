import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:eventix/features/reservations/domain/repositories/reservation_repository.dart';

class GetReservationById {
  const GetReservationById(this._repository);

  final ReservationRepository _repository;

  Future<Result<ReservationDetail>> call(String reservationId) =>
      _repository.getReservationById(reservationId);
}
