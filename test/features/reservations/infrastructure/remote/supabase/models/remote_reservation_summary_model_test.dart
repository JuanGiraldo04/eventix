import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_summary_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteReservationSummaryModel.fromJson', () {
    test(
      'given a json payload with a nested events join '
      'when fromJson is called '
      'then returns a RemoteReservationSummaryModel with every field mapped',
      () {
        final RemoteReservationSummaryModel model =
            RemoteReservationSummaryModel.fromJson(const <String, dynamic>{
              'id': 'res-1',
              'evento_id': 'event-1',
              'estado': 'confirmada',
              'cantidad_entradas': 2,
              'total': 170000.0,
              'events': <String, dynamic>{
                'titulo': 'Festival de Rock',
                'imagen_url': 'https://example.com/event.jpg',
                'fecha': '2026-03-05',
                'ciudad': 'Bogotá',
              },
            });

        expect(model.id, 'res-1');
        expect(model.eventoId, 'event-1');
        expect(model.estado, 'confirmada');
        expect(model.cantidadEntradas, 2);
        expect(model.total, 170000.0);
        expect(model.eventoTitulo, 'Festival de Rock');
        expect(model.eventoImagenUrl, 'https://example.com/event.jpg');
        expect(model.eventoFecha, '2026-03-05');
        expect(model.eventoCiudad, 'Bogotá');
      },
    );

    test(
      'given a json payload with no events join '
      'when fromJson is called '
      'then throws a type error',
      () {
        expect(
          () => RemoteReservationSummaryModel.fromJson(const <String, dynamic>{
            'id': 'res-1',
            'evento_id': 'event-1',
            'estado': 'confirmada',
            'cantidad_entradas': 2,
            'total': 170000.0,
          }),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });
}
