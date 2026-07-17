class RemoteReservationSummaryModel {
  const RemoteReservationSummaryModel({
    required this.id,
    required this.eventoId,
    required this.estado,
    required this.cantidadEntradas,
    required this.total,
    required this.eventoTitulo,
    required this.eventoImagenUrl,
    required this.eventoFecha,
    required this.eventoCiudad,
  });

  final String id;
  final String eventoId;
  final String estado;
  final int cantidadEntradas;
  final double total;
  final String eventoTitulo;
  final String eventoImagenUrl;
  final String eventoFecha;
  final String eventoCiudad;

  factory RemoteReservationSummaryModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> evento = json['events'] as Map<String, dynamic>;
    return RemoteReservationSummaryModel(
      id: json['id'] as String,
      eventoId: json['evento_id'] as String,
      estado: json['estado'] as String,
      cantidadEntradas: json['cantidad_entradas'] as int,
      total: (json['total'] as num).toDouble(),
      eventoTitulo: evento['titulo'] as String,
      eventoImagenUrl: evento['imagen_url'] as String,
      eventoFecha: evento['fecha'] as String,
      eventoCiudad: evento['ciudad'] as String,
    );
  }
}
