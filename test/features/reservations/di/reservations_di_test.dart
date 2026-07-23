import 'package:eventix/core/services/supabase/supabase_provider.dart';
import 'package:eventix/features/reservations/di/reservations_di.dart';
import 'package:eventix/features/reservations/domain/usecases/confirm_reservation.dart';
import 'package:eventix/features/reservations/domain/usecases/create_reservation.dart';
import 'package:eventix/features/reservations/domain/usecases/get_my_reservations.dart';
import 'package:eventix/features/reservations/domain/usecases/get_reservation_by_id.dart';
import 'package:eventix/features/reservations/domain/usecases/update_reservation_quantity.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/datasource/supabase_reservation_datasource.dart';
import 'package:eventix/features/reservations/infrastructure/repositories/reservation_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/src/framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test(
    'given a SupabaseClient override '
    'when the reservations DI providers are read '
    'then each one resolves the expected concrete type',
    () {
      final SupabaseClient client = SupabaseClient(
        'https://example.supabase.co',
        'anon-key',
      );
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          supabaseClientProvider.overrideWithValue(client),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(reservationRemoteDatasourceProvider),
        isA<SupabaseReservationDatasource>(),
      );
      expect(
        container.read(reservationRepositoryProvider),
        isA<ReservationRepositoryImpl>(),
      );
      expect(
        container.read(createReservationProvider),
        isA<CreateReservation>(),
      );
      expect(
        container.read(updateReservationQuantityProvider),
        isA<UpdateReservationQuantity>(),
      );
      expect(
        container.read(confirmReservationProvider),
        isA<ConfirmReservation>(),
      );
      expect(
        container.read(getMyReservationsProvider),
        isA<GetMyReservations>(),
      );
      expect(
        container.read(getReservationByIdProvider),
        isA<GetReservationById>(),
      );
    },
  );
}
