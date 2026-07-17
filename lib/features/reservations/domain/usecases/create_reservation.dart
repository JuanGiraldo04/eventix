import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/domain/repositories/reservation_repository.dart';

class CreateReservation {
  const CreateReservation(this._repository);

  final ReservationRepository _repository;

  Future<Result<Reservation>> call({
    required String eventoId,
    required int cantidadEntradas,
    required double total,
  }) => _repository.createReservation(
    eventoId: eventoId,
    cantidadEntradas: cantidadEntradas,
    total: total,
  );
}
