import 'package:eventix/features/reservations/domain/entities/reservation_summary.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_summary_model.dart';

class RemoteReservationSummaryMapper {
  const RemoteReservationSummaryMapper._();

  static ReservationSummary toEntity(RemoteReservationSummaryModel model) =>
      ReservationSummary(
        id: model.id,
        eventoId: model.eventoId,
        estado: model.estado,
        cantidadEntradas: model.cantidadEntradas,
        total: model.total,
        eventoTitulo: model.eventoTitulo,
        eventoImagenUrl: model.eventoImagenUrl,
        eventoFecha: DateTime.parse(model.eventoFecha),
        eventoCiudad: model.eventoCiudad,
      );

  static List<ReservationSummary> toEntities(
    List<RemoteReservationSummaryModel> models,
  ) => models.map(toEntity).toList();
}
