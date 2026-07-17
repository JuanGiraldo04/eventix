class RemoteEventModel {
  const RemoteEventModel({
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
  final String fecha;
  final String hora;
  final double precio;
  final int capacidad;
  final int cuposDisponibles;

  factory RemoteEventModel.fromJson(Map<String, dynamic> json) =>
      RemoteEventModel(
        id: json['id'] as String,
        titulo: json['titulo'] as String,
        descripcion: json['descripcion'] as String,
        imagenUrl: json['imagen_url'] as String,
        categoria: json['categoria'] as String,
        ciudad: json['ciudad'] as String,
        fecha: json['fecha'] as String,
        hora: json['hora'] as String,
        precio: (json['precio'] as num).toDouble(),
        capacidad: json['capacidad'] as int,
        cuposDisponibles: json['cupos_disponibles'] as int,
      );
}
