import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/mappers/remote_ticket_mapper.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_detail_model.dart';

class RemoteReservationDetailMapper {
  const RemoteReservationDetailMapper._();

  static ReservationDetail toEntity(RemoteReservationDetailModel model) =>
      ReservationDetail(
        id: model.id,
        eventoId: model.eventoId,
        estado: model.estado,
        cantidadEntradas: model.cantidadEntradas,
        total: model.total,
        eventoTitulo: model.eventoTitulo,
        eventoImagenUrl: model.eventoImagenUrl,
        eventoFecha: DateTime.parse(model.eventoFecha),
        eventoHora: model.eventoHora.substring(0, 5),
        eventoCiudad: model.eventoCiudad,
        tickets: RemoteTicketMapper.toEntities(model.tickets),
      );
}
