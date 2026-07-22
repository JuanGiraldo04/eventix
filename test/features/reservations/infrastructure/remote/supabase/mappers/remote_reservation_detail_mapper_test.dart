import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/mappers/remote_reservation_detail_mapper.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_detail_model.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_ticket_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteReservationDetailMapper.toEntity', () {
    const RemoteReservationDetailModel model = RemoteReservationDetailModel(
      id: 'res-1',
      eventoId: 'event-1',
      estado: 'confirmada',
      cantidadEntradas: 2,
      total: 170000.0,
      eventoTitulo: 'Festival de Rock',
      eventoImagenUrl: 'https://example.com/event.jpg',
      eventoFecha: '2026-03-05',
      eventoHora: '20:00:00',
      eventoCiudad: 'Bogotá',
      tickets: <RemoteTicketModel>[
        RemoteTicketModel(id: 'ticket-1', codigo: 'AB12-CD34'),
        RemoteTicketModel(id: 'ticket-2', codigo: 'EF56-GH78'),
      ],
    );

    test(
      'given a RemoteReservationDetailModel '
      'when toEntity is called '
      'then eventoFecha is parsed into a DateTime',
      () {
        final ReservationDetail detail = RemoteReservationDetailMapper.toEntity(
          model,
        );

        expect(detail.eventoFecha, DateTime.parse('2026-03-05'));
      },
    );

    test(
      'given a RemoteReservationDetailModel with a full HH:mm:ss hora '
      'when toEntity is called '
      'then eventoHora is truncated to HH:mm',
      () {
        final ReservationDetail detail = RemoteReservationDetailMapper.toEntity(
          model,
        );

        expect(detail.eventoHora, '20:00');
      },
    );

    test(
      'given a RemoteReservationDetailModel with tickets '
      'when toEntity is called '
      'then every ticket is mapped to a Ticket entity',
      () {
        final ReservationDetail detail = RemoteReservationDetailMapper.toEntity(
          model,
        );

        expect(detail.tickets, hasLength(2));
        expect(detail.tickets[0].codigo, 'AB12-CD34');
        expect(detail.tickets[1].codigo, 'EF56-GH78');
      },
    );

    test(
      'given a RemoteReservationDetailModel '
      'when toEntity is called '
      'then the remaining fields are copied unchanged',
      () {
        final ReservationDetail detail = RemoteReservationDetailMapper.toEntity(
          model,
        );

        expect(detail.id, model.id);
        expect(detail.eventoId, model.eventoId);
        expect(detail.estado, model.estado);
        expect(detail.cantidadEntradas, model.cantidadEntradas);
        expect(detail.total, model.total);
        expect(detail.eventoTitulo, model.eventoTitulo);
        expect(detail.eventoImagenUrl, model.eventoImagenUrl);
        expect(detail.eventoCiudad, model.eventoCiudad);
      },
    );
  });
}
