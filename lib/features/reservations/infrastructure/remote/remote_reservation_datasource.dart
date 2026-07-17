import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_detail_model.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_model.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_summary_model.dart';

abstract interface class ReservationRemoteDatasource {
  Future<RemoteReservationModel> createReservation({
    required String eventoId,
    required int cantidadEntradas,
    required double total,
  });

  Future<RemoteReservationModel> updateReservationQuantity({
    required String reservationId,
    required int cantidadEntradas,
    required double total,
  });

  Future<RemoteReservationModel> confirmReservation(String reservationId);

  Future<List<RemoteReservationSummaryModel>> getMyReservations();

  Future<RemoteReservationDetailModel> getReservationById(
    String reservationId,
  );
}
