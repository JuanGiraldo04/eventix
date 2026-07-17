import 'package:eventix/features/reservations/domain/entities/ticket.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_ticket_model.dart';

class RemoteTicketMapper {
  const RemoteTicketMapper._();

  static Ticket toEntity(RemoteTicketModel model) =>
      Ticket(id: model.id, codigo: model.codigo);

  static List<Ticket> toEntities(List<RemoteTicketModel> models) =>
      models.map(toEntity).toList();
}
