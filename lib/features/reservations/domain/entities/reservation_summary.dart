class ReservationSummary {
  const ReservationSummary({
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
  final DateTime eventoFecha;
  final String eventoCiudad;
}
