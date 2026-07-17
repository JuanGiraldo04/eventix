import 'package:eventix/features/reservations/domain/entities/ticket.dart';

class ReservationDetail {
  const ReservationDetail({
    required this.id,
    required this.eventoId,
    required this.estado,
    required this.cantidadEntradas,
    required this.total,
    required this.eventoTitulo,
    required this.eventoImagenUrl,
    required this.eventoFecha,
    required this.eventoHora,
    required this.eventoCiudad,
    required this.tickets,
  });

  final String id;
  final String eventoId;
  final String estado;
  final int cantidadEntradas;
  final double total;
  final String eventoTitulo;
  final String eventoImagenUrl;
  final DateTime eventoFecha;
  final String eventoHora;
  final String eventoCiudad;
  final List<Ticket> tickets;
}
