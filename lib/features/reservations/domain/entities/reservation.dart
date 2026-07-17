const String kReservationPendiente = 'pendiente';
const String kReservationConfirmada = 'confirmada';
const String kReservationCancelada = 'cancelada';

class Reservation {
  const Reservation({
    required this.id,
    required this.usuarioId,
    required this.eventoId,
    required this.cantidadEntradas,
    required this.total,
    required this.estado,
  });

  final String id;
  final String usuarioId;
  final String eventoId;
  final int cantidadEntradas;
  final double total;
  final String estado;
}
