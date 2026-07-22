import 'package:eventix/features/reservations/domain/entities/reservation_summary.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/mappers/remote_reservation_summary_mapper.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_summary_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteReservationSummaryMapper.toEntity', () {
    const RemoteReservationSummaryModel model = RemoteReservationSummaryModel(
      id: 'res-1',
      eventoId: 'event-1',
      estado: 'confirmada',
      cantidadEntradas: 2,
      total: 170000.0,
      eventoTitulo: 'Festival de Rock',
      eventoImagenUrl: 'https://example.com/event.jpg',
      eventoFecha: '2026-03-05',
      eventoCiudad: 'Bogotá',
    );

    test(
      'given a RemoteReservationSummaryModel '
      'when toEntity is called '
      'then eventoFecha is parsed into a DateTime',
      () {
        final ReservationSummary summary =
            RemoteReservationSummaryMapper.toEntity(model);

        expect(summary.eventoFecha, DateTime.parse('2026-03-05'));
      },
    );

    test(
      'given a RemoteReservationSummaryModel '
      'when toEntity is called '
      'then the remaining fields are copied unchanged',
      () {
        final ReservationSummary summary =
            RemoteReservationSummaryMapper.toEntity(model);

        expect(summary.id, model.id);
        expect(summary.eventoId, model.eventoId);
        expect(summary.estado, model.estado);
        expect(summary.cantidadEntradas, model.cantidadEntradas);
        expect(summary.total, model.total);
        expect(summary.eventoTitulo, model.eventoTitulo);
        expect(summary.eventoImagenUrl, model.eventoImagenUrl);
        expect(summary.eventoCiudad, model.eventoCiudad);
      },
    );

    test(
      'given a list of models '
      'when toEntities is called '
      'then returns the mapped entity for each one, in order',
      () {
        final List<ReservationSummary> summaries =
            RemoteReservationSummaryMapper.toEntities(
              <RemoteReservationSummaryModel>[model, model],
            );

        expect(summaries, hasLength(2));
      },
    );
  });
}
