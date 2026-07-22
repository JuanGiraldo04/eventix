import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteReservationDetailModel.fromJson', () {
    test(
      'given a json payload with a nested events join and tickets '
      'when fromJson is called '
      'then returns a RemoteReservationDetailModel with every field mapped',
      () {
        final RemoteReservationDetailModel model =
            RemoteReservationDetailModel.fromJson(const <String, dynamic>{
              'id': 'res-1',
              'evento_id': 'event-1',
              'estado': 'confirmada',
              'cantidad_entradas': 2,
              'total': 170000.0,
              'events': <String, dynamic>{
                'titulo': 'Festival de Rock',
                'imagen_url': 'https://example.com/event.jpg',
                'fecha': '2026-03-05',
                'hora': '20:00:00',
                'ciudad': 'Bogotá',
              },
              'tickets': <Map<String, dynamic>>[
                <String, dynamic>{'id': 'ticket-1', 'codigo': 'AB12-CD34'},
                <String, dynamic>{'id': 'ticket-2', 'codigo': 'EF56-GH78'},
              ],
            });

        expect(model.id, 'res-1');
        expect(model.eventoId, 'event-1');
        expect(model.estado, 'confirmada');
        expect(model.cantidadEntradas, 2);
        expect(model.total, 170000.0);
        expect(model.eventoTitulo, 'Festival de Rock');
        expect(model.eventoImagenUrl, 'https://example.com/event.jpg');
        expect(model.eventoFecha, '2026-03-05');
        expect(model.eventoHora, '20:00:00');
        expect(model.eventoCiudad, 'Bogotá');
        expect(model.tickets, hasLength(2));
        expect(model.tickets[0].codigo, 'AB12-CD34');
        expect(model.tickets[1].codigo, 'EF56-GH78');
      },
    );

    test(
      'given a json payload with no tickets key '
      'when fromJson is called '
      'then tickets defaults to an empty list',
      () {
        final RemoteReservationDetailModel model =
            RemoteReservationDetailModel.fromJson(const <String, dynamic>{
              'id': 'res-1',
              'evento_id': 'event-1',
              'estado': 'pendiente',
              'cantidad_entradas': 1,
              'total': 85000.0,
              'events': <String, dynamic>{
                'titulo': 'Festival de Rock',
                'imagen_url': 'https://example.com/event.jpg',
                'fecha': '2026-03-05',
                'hora': '20:00:00',
                'ciudad': 'Bogotá',
              },
            });

        expect(model.tickets, isEmpty);
      },
    );
  });
}
