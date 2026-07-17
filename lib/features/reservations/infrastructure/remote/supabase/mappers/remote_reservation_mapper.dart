import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_model.dart';

class RemoteReservationMapper {
  const RemoteReservationMapper._();

  static Reservation toEntity(RemoteReservationModel model) => Reservation(
    id: model.id,
    usuarioId: model.usuarioId,
    eventoId: model.eventoId,
    cantidadEntradas: model.cantidadEntradas,
    total: model.total,
    estado: model.estado,
  );
}
