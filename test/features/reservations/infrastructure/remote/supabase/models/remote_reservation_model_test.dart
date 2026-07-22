import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteReservationModel.fromJson', () {
    test(
      'given a full json payload '
      'when fromJson is called '
      'then returns a RemoteReservationModel with every field mapped',
      () {
        final RemoteReservationModel model = RemoteReservationModel.fromJson(
          const <String, dynamic>{
            'id': 'res-1',
            'usuario_id': 'user-1',
            'evento_id': 'event-1',
            'cantidad_entradas': 2,
            'total': 170000.0,
            'estado': 'pendiente',
          },
        );

        expect(model.id, 'res-1');
        expect(model.usuarioId, 'user-1');
        expect(model.eventoId, 'event-1');
        expect(model.cantidadEntradas, 2);
        expect(model.total, 170000.0);
        expect(model.estado, 'pendiente');
      },
    );

    test(
      'given total as an int '
      'when fromJson is called '
      'then total is converted to a double',
      () {
        final RemoteReservationModel model = RemoteReservationModel.fromJson(
          const <String, dynamic>{
            'id': 'res-1',
            'usuario_id': 'user-1',
            'evento_id': 'event-1',
            'cantidad_entradas': 2,
            'total': 170000,
            'estado': 'pendiente',
          },
        );

        expect(model.total, isA<double>());
        expect(model.total, 170000.0);
      },
    );
  });
}
