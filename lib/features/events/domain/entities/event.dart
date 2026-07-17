const List<String> kEventCategories = <String>[
  'Fútbol',
  'Baloncesto',
  'Tenis',
  'Atletismo',
  'Natación',
];

const List<String> kEventCities = <String>[
  'Bogotá',
  'Medellín',
  'Cali',
  'Barranquilla',
  'Cartagena',
];

class Event {
  const Event({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagenUrl,
    required this.categoria,
    required this.ciudad,
    required this.fecha,
    required this.hora,
    required this.precio,
    required this.capacidad,
    required this.cuposDisponibles,
  });

  final String id;
  final String titulo;
  final String descripcion;
  final String imagenUrl;
  final String categoria;
  final String ciudad;
  final DateTime fecha;
  final String hora;
  final double precio;
  final int capacidad;
  final int cuposDisponibles;

  bool get tieneCupos => cuposDisponibles > 0;
}
