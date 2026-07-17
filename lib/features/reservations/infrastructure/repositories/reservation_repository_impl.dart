import 'package:eventix/core/helpers/execute_repository_call.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_summary.dart';
import 'package:eventix/features/reservations/domain/repositories/reservation_repository.dart';
import 'package:eventix/features/reservations/infrastructure/remote/remote_reservation_datasource.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/mappers/remote_reservation_detail_mapper.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/mappers/remote_reservation_mapper.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/mappers/remote_reservation_summary_mapper.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_detail_model.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_model.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_summary_model.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  const ReservationRepositoryImpl(this._remoteDatasource);

  final ReservationRemoteDatasource _remoteDatasource;

  @override
  Future<Result<Reservation>> createReservation({
    required String eventoId,
    required int cantidadEntradas,
    required double total,
  }) {
    return executeRepositoryCall(() async {
      final RemoteReservationModel model = await _remoteDatasource
          .createReservation(
            eventoId: eventoId,
            cantidadEntradas: cantidadEntradas,
            total: total,
          );
      return RemoteReservationMapper.toEntity(model);
    });
  }

  @override
  Future<Result<Reservation>> updateReservationQuantity({
    required String reservationId,
    required int cantidadEntradas,
    required double total,
  }) {
    return executeRepositoryCall(() async {
      final RemoteReservationModel model = await _remoteDatasource
          .updateReservationQuantity(
            reservationId: reservationId,
            cantidadEntradas: cantidadEntradas,
            total: total,
          );
      return RemoteReservationMapper.toEntity(model);
    });
  }

  @override
  Future<Result<Reservation>> confirmReservation(String reservationId) {
    return executeRepositoryCall(() async {
      final RemoteReservationModel model = await _remoteDatasource
          .confirmReservation(reservationId);
      return RemoteReservationMapper.toEntity(model);
    });
  }

  @override
  Future<Result<List<ReservationSummary>>> getMyReservations() {
    return executeRepositoryCall(() async {
      final List<RemoteReservationSummaryModel> models = await _remoteDatasource
          .getMyReservations();
      return RemoteReservationSummaryMapper.toEntities(models);
    });
  }

  @override
  Future<Result<ReservationDetail>> getReservationById(
    String reservationId,
  ) {
    return executeRepositoryCall(() async {
      final RemoteReservationDetailModel model = await _remoteDatasource
          .getReservationById(reservationId);
      return RemoteReservationDetailMapper.toEntity(model);
    });
  }
}
