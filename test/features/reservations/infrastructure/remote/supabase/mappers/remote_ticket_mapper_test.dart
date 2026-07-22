import 'package:eventix/features/reservations/domain/entities/ticket.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/mappers/remote_ticket_mapper.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_ticket_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteTicketMapper', () {
    const RemoteTicketModel model = RemoteTicketModel(
      id: 'ticket-1',
      codigo: 'AB12-CD34',
    );

    test(
      'given a RemoteTicketModel '
      'when toEntity is called '
      'then returns a Ticket with the same field values',
      () {
        final Ticket ticket = RemoteTicketMapper.toEntity(model);

        expect(ticket.id, model.id);
        expect(ticket.codigo, model.codigo);
      },
    );

    test(
      'given a list of models '
      'when toEntities is called '
      'then returns the mapped entity for each one, in order',
      () {
        const RemoteTicketModel otherModel = RemoteTicketModel(
          id: 'ticket-2',
          codigo: 'EF56-GH78',
        );

        final List<Ticket> tickets = RemoteTicketMapper.toEntities(
          <RemoteTicketModel>[model, otherModel],
        );

        expect(tickets, hasLength(2));
        expect(tickets[0].codigo, 'AB12-CD34');
        expect(tickets[1].codigo, 'EF56-GH78');
      },
    );
  });
}
