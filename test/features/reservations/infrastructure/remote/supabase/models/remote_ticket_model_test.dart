import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_ticket_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteTicketModel.fromJson', () {
    test(
      'given a full json payload '
      'when fromJson is called '
      'then returns a RemoteTicketModel with every field mapped',
      () {
        final RemoteTicketModel model = RemoteTicketModel.fromJson(
          const <String, dynamic>{'id': 'ticket-1', 'codigo': 'AB12-CD34'},
        );

        expect(model.id, 'ticket-1');
        expect(model.codigo, 'AB12-CD34');
      },
    );
  });
}
