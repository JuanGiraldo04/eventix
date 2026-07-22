import 'package:eventix/features/events/infrastructure/remote/supabase/models/remote_event_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteEventModel.fromJson', () {
    test(
      'given a full json payload '
      'when fromJson is called '
      'then returns a RemoteEventModel with every field mapped',
      () {
        final RemoteEventModel model = RemoteEventModel.fromJson(
          const <String, dynamic>{
            'id': 'event-1',
            'titulo': 'Festival de Rock',
            'descripcion': 'Un festival',
            'imagen_url': 'https://example.com/event.jpg',
            'categoria': 'Conciertos',
            'ciudad': 'Bogotá',
            'fecha': '2026-03-05',
            'hora': '20:00:00',
            'precio': 85000.0,
            'capacidad': 100,
            'cupos_disponibles': 40,
          },
        );

        expect(model.id, 'event-1');
        expect(model.titulo, 'Festival de Rock');
        expect(model.descripcion, 'Un festival');
        expect(model.imagenUrl, 'https://example.com/event.jpg');
        expect(model.categoria, 'Conciertos');
        expect(model.ciudad, 'Bogotá');
        expect(model.fecha, '2026-03-05');
        expect(model.hora, '20:00:00');
        expect(model.precio, 85000.0);
        expect(model.capacidad, 100);
        expect(model.cuposDisponibles, 40);
      },
    );

    test(
      'given precio as an int (Supabase numeric without decimals) '
      'when fromJson is called '
      'then precio is converted to a double',
      () {
        final RemoteEventModel model = RemoteEventModel.fromJson(
          const <String, dynamic>{
            'id': 'event-1',
            'titulo': 'Festival de Rock',
            'descripcion': 'Un festival',
            'imagen_url': 'https://example.com/event.jpg',
            'categoria': 'Conciertos',
            'ciudad': 'Bogotá',
            'fecha': '2026-03-05',
            'hora': '20:00:00',
            'precio': 85000,
            'capacidad': 100,
            'cupos_disponibles': 40,
          },
        );

        expect(model.precio, isA<double>());
        expect(model.precio, 85000.0);
      },
    );
  });
}
