import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/mappers/remote_reservation_mapper.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteReservationMapper.toEntity', () {
    test(
      'given a RemoteReservationModel '
      'when toEntity is called '
      'then returns a Reservation with the same field values',
      () {
        const RemoteReservationModel model = RemoteReservationModel(
          id: 'res-1',
          usuarioId: 'user-1',
          eventoId: 'event-1',
          cantidadEntradas: 2,
          total: 170000.0,
          estado: kReservationPendiente,
        );

        final Reservation reservation = RemoteReservationMapper.toEntity(
          model,
        );

        expect(reservation.id, model.id);
        expect(reservation.usuarioId, model.usuarioId);
        expect(reservation.eventoId, model.eventoId);
        expect(reservation.cantidadEntradas, model.cantidadEntradas);
        expect(reservation.total, model.total);
        expect(reservation.estado, kReservationPendiente);
      },
    );
  });
}
