import 'package:eventix/features/events/domain/entities/event_filter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_filter_provider.g.dart';

@riverpod
class EventFilterNotifier extends _$EventFilterNotifier {
  @override
  EventFilter build() => const EventFilter();

  void setQuery(String query) => state = EventFilter(
    query: query,
    categoria: state.categoria,
    ciudad: state.ciudad,
    fecha: state.fecha,
  );

  void setCategoria(String? categoria) => state = EventFilter(
    query: state.query,
    categoria: categoria,
    ciudad: state.ciudad,
    fecha: state.fecha,
  );

  void setCiudad(String? ciudad) => state = EventFilter(
    query: state.query,
    categoria: state.categoria,
    ciudad: ciudad,
    fecha: state.fecha,
  );

  void setFecha(DateTime? fecha) => state = EventFilter(
    query: state.query,
    categoria: state.categoria,
    ciudad: state.ciudad,
    fecha: fecha,
  );

  void clear() => state = const EventFilter();
}
