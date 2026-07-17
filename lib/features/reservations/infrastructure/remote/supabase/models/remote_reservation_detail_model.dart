import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_ticket_model.dart';

class RemoteReservationDetailModel {
  const RemoteReservationDetailModel({
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
  final String eventoFecha;
  final String eventoHora;
  final String eventoCiudad;
  final List<RemoteTicketModel> tickets;

  factory RemoteReservationDetailModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> evento = json['events'] as Map<String, dynamic>;
    final List<dynamic> ticketsJson =
        (json['tickets'] as List<dynamic>?) ?? <dynamic>[];
    return RemoteReservationDetailModel(
      id: json['id'] as String,
      eventoId: json['evento_id'] as String,
      estado: json['estado'] as String,
      cantidadEntradas: json['cantidad_entradas'] as int,
      total: (json['total'] as num).toDouble(),
      eventoTitulo: evento['titulo'] as String,
      eventoImagenUrl: evento['imagen_url'] as String,
      eventoFecha: evento['fecha'] as String,
      eventoHora: evento['hora'] as String,
      eventoCiudad: evento['ciudad'] as String,
      tickets: ticketsJson
          .map(
            (dynamic e) =>
                RemoteTicketModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
