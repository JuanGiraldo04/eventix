import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_summary.dart';
import 'package:eventix/features/reservations/domain/repositories/reservation_repository.dart';

class GetMyReservations {
  const GetMyReservations(this._repository);

  final ReservationRepository _repository;

  Future<Result<List<ReservationSummary>>> call() =>
      _repository.getMyReservations();
}
