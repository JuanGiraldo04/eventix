class RemoteReservationModel {
  const RemoteReservationModel({
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

  factory RemoteReservationModel.fromJson(Map<String, dynamic> json) =>
      RemoteReservationModel(
        id: json['id'] as String,
        usuarioId: json['usuario_id'] as String,
        eventoId: json['evento_id'] as String,
        cantidadEntradas: json['cantidad_entradas'] as int,
        total: (json['total'] as num).toDouble(),
        estado: json['estado'] as String,
      );
}
