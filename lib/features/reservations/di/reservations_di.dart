import 'package:eventix/core/services/supabase/supabase_provider.dart';
import 'package:eventix/features/reservations/domain/usecases/confirm_reservation.dart';
import 'package:eventix/features/reservations/domain/usecases/create_reservation.dart';
import 'package:eventix/features/reservations/domain/usecases/get_my_reservations.dart';
import 'package:eventix/features/reservations/domain/usecases/get_reservation_by_id.dart';
import 'package:eventix/features/reservations/domain/usecases/update_reservation_quantity.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/datasource/supabase_reservation_datasource.dart';
import 'package:eventix/features/reservations/infrastructure/repositories/reservation_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reservations_di.g.dart';

@riverpod
SupabaseReservationDatasource reservationRemoteDatasource(Ref ref) =>
    SupabaseReservationDatasource(ref.watch(supabaseClientProvider));

@riverpod
ReservationRepositoryImpl reservationRepository(Ref ref) =>
    ReservationRepositoryImpl(ref.watch(reservationRemoteDatasourceProvider));

@riverpod
CreateReservation createReservation(Ref ref) =>
    CreateReservation(ref.watch(reservationRepositoryProvider));

@riverpod
UpdateReservationQuantity updateReservationQuantity(Ref ref) =>
    UpdateReservationQuantity(ref.watch(reservationRepositoryProvider));

@riverpod
ConfirmReservation confirmReservation(Ref ref) =>
    ConfirmReservation(ref.watch(reservationRepositoryProvider));

@riverpod
GetMyReservations getMyReservations(Ref ref) =>
    GetMyReservations(ref.watch(reservationRepositoryProvider));

@riverpod
GetReservationById getReservationById(Ref ref) =>
    GetReservationById(ref.watch(reservationRepositoryProvider));
