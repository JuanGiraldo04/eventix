class RemoteTicketModel {
  const RemoteTicketModel({required this.id, required this.codigo});

  final String id;
  final String codigo;

  factory RemoteTicketModel.fromJson(Map<String, dynamic> json) =>
      RemoteTicketModel(
        id: json['id'] as String,
        codigo: json['codigo'] as String,
      );
}
