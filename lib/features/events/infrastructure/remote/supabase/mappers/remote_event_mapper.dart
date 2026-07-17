import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/infrastructure/remote/supabase/models/remote_event_model.dart';

class RemoteEventMapper {
  const RemoteEventMapper._();

  static Event toEntity(RemoteEventModel model) => Event(
    id: model.id,
    titulo: model.titulo,
    descripcion: model.descripcion,
    imagenUrl: model.imagenUrl,
    categoria: model.categoria,
    ciudad: model.ciudad,
    fecha: DateTime.parse(model.fecha),
    hora: model.hora.substring(0, 5),
    precio: model.precio,
    capacidad: model.capacidad,
    cuposDisponibles: model.cuposDisponibles,
  );

  static List<Event> toEntities(List<RemoteEventModel> models) =>
      models.map(toEntity).toList();
}
