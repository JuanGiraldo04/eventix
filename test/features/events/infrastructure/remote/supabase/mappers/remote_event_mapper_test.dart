import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/infrastructure/remote/supabase/mappers/remote_event_mapper.dart';
import 'package:eventix/features/events/infrastructure/remote/supabase/models/remote_event_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteEventMapper.toEntity', () {
    const RemoteEventModel model = RemoteEventModel(
      id: 'event-1',
      titulo: 'Festival de Rock',
      descripcion: 'Un festival',
      imagenUrl: 'https://example.com/event.jpg',
      categoria: 'Conciertos',
      ciudad: 'Bogotá',
      fecha: '2026-03-05',
      hora: '20:00:00',
      precio: 85000.0,
      capacidad: 100,
      cuposDisponibles: 40,
    );

    test(
      'given a RemoteEventModel '
      'when toEntity is called '
      'then fecha is parsed into a DateTime',
      () {
        final Event event = RemoteEventMapper.toEntity(model);

        expect(event.fecha, DateTime.parse('2026-03-05'));
      },
    );

    test(
      'given a RemoteEventModel with a full HH:mm:ss hora '
      'when toEntity is called '
      'then hora is truncated to HH:mm',
      () {
        final Event event = RemoteEventMapper.toEntity(model);

        expect(event.hora, '20:00');
      },
    );

    test(
      'given a RemoteEventModel '
      'when toEntity is called '
      'then the remaining fields are copied unchanged',
      () {
        final Event event = RemoteEventMapper.toEntity(model);

        expect(event.id, model.id);
        expect(event.titulo, model.titulo);
        expect(event.descripcion, model.descripcion);
        expect(event.imagenUrl, model.imagenUrl);
        expect(event.categoria, model.categoria);
        expect(event.ciudad, model.ciudad);
        expect(event.precio, model.precio);
        expect(event.capacidad, model.capacidad);
        expect(event.cuposDisponibles, model.cuposDisponibles);
      },
    );

    test(
      'given a list of models '
      'when toEntities is called '
      'then returns the mapped entity for each one, in order',
      () {
        const RemoteEventModel otherModel = RemoteEventModel(
          id: 'event-2',
          titulo: 'Final de Copa',
          descripcion: 'Un partido',
          imagenUrl: 'https://example.com/event2.jpg',
          categoria: 'Deportes',
          ciudad: 'Medellín',
          fecha: '2026-04-01',
          hora: '15:00:00',
          precio: 45000.0,
          capacidad: 200,
          cuposDisponibles: 0,
        );

        final List<Event> events = RemoteEventMapper.toEntities(
          <RemoteEventModel>[model, otherModel],
        );

        expect(events, hasLength(2));
        expect(events[0].id, 'event-1');
        expect(events[1].id, 'event-2');
      },
    );
  });
}
