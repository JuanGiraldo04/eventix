import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_summary.dart';
import 'package:eventix/features/reservations/domain/repositories/reservation_repository.dart';
import 'package:eventix/features/reservations/domain/usecases/get_my_reservations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReservationRepository extends Mock implements ReservationRepository {}

void main() {
  late MockReservationRepository repository;
  late GetMyReservations usecase;

  setUp(() {
    repository = MockReservationRepository();
    usecase = GetMyReservations(repository);
  });

  group('GetMyReservations', () {
    final ReservationSummary summary = ReservationSummary(
      id: 'res-1',
      eventoId: 'event-1',
      estado: 'confirmada',
      cantidadEntradas: 2,
      total: 170000,
      eventoTitulo: 'Festival de Rock',
      eventoImagenUrl: 'https://example.com/event.jpg',
      eventoFecha: DateTime(2026, 3, 5),
      eventoCiudad: 'Bogotá',
    );

    test(
      'given the user has reservations '
      'when call is invoked '
      'then it calls ReservationRepository.getMyReservations and returns '
      'the list',
      () async {
        when(repository.getMyReservations).thenAnswer(
          (Invocation _) async =>
              Success<List<ReservationSummary>>(<ReservationSummary>[summary]),
        );

        final Result<List<ReservationSummary>> result = await usecase.call();

        expect(result, isA<Success<List<ReservationSummary>>>());
        expect(
          (result as Success<List<ReservationSummary>>).data,
          <ReservationSummary>[summary],
        );
        verify(repository.getMyReservations).called(1);
      },
    );

    test(
      'given the repository returns a failure '
      'when call is invoked '
      'then it returns the same failure unchanged',
      () async {
        when(repository.getMyReservations).thenAnswer(
          (Invocation _) async => const FailureResult<List<ReservationSummary>>(
            ConnectionFailure(),
          ),
        );

        final Result<List<ReservationSummary>> result = await usecase.call();

        expect(result, isA<FailureResult<List<ReservationSummary>>>());
        expect(
          (result as FailureResult<List<ReservationSummary>>).failure,
          isA<ConnectionFailure>(),
        );
      },
    );
  });
}
