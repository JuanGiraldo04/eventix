import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/errors/supabase_error_mapper.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/infrastructure/remote/remote_reservation_datasource.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_detail_model.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_model.dart';
import 'package:eventix/features/reservations/infrastructure/remote/supabase/models/remote_reservation_summary_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String _eventJoin = 'titulo, imagen_url, fecha, hora, ciudad';

class SupabaseReservationDatasource implements ReservationRemoteDatasource {
  const SupabaseReservationDatasource(this._client);

  final SupabaseClient _client;

  @override
  Future<RemoteReservationModel> createReservation({
    required String eventoId,
    required int cantidadEntradas,
    required double total,
  }) async {
    try {
      final String? usuarioId = _client.auth.currentUser?.id;
      if (usuarioId == null) {
        throw const UnauthorizedFailure('Debes iniciar sesión');
      }

      final Map<String, dynamic> data = await _client
          .from('reservations')
          .insert(<String, Object>{
            'usuario_id': usuarioId,
            'evento_id': eventoId,
            'cantidad_entradas': cantidadEntradas,
            'total': total,
            'estado': kReservationPendiente,
          })
          .select()
          .single();
      return RemoteReservationModel.fromJson(data);
    } catch (e) {
      if (e is Failure) rethrow;
      throw mapSupabaseError(e);
    }
  }

  @override
  Future<RemoteReservationModel> updateReservationQuantity({
    required String reservationId,
    required int cantidadEntradas,
    required double total,
  }) async {
    try {
      final Map<String, dynamic> data = await _client
          .from('reservations')
          .update(<String, Object>{
            'cantidad_entradas': cantidadEntradas,
            'total': total,
          })
          .eq('id', reservationId)
          .select()
          .single();
      return RemoteReservationModel.fromJson(data);
    } catch (e) {
      throw mapSupabaseError(e);
    }
  }

  @override
  Future<RemoteReservationModel> confirmReservation(
    String reservationId,
  ) async {
    try {
      final Map<String, dynamic> data = await _client.rpc(
        'confirmar_reserva',
        params: <String, dynamic>{'p_reserva_id': reservationId},
      );
      return RemoteReservationModel.fromJson(data);
    } catch (e) {
      throw mapSupabaseError(e);
    }
  }

  @override
  Future<List<RemoteReservationSummaryModel>> getMyReservations() async {
    try {
      final List<Map<String, dynamic>> data = await _client
          .from('reservations')
          .select('*, events($_eventJoin)')
          .order('created_at', ascending: false);
      return data.map(RemoteReservationSummaryModel.fromJson).toList();
    } catch (e) {
      throw mapSupabaseError(e);
    }
  }

  @override
  Future<RemoteReservationDetailModel> getReservationById(
    String reservationId,
  ) async {
    try {
      final Map<String, dynamic> data = await _client
          .from('reservations')
          .select('*, events($_eventJoin), tickets(id, codigo)')
          .eq('id', reservationId)
          .single();
      return RemoteReservationDetailModel.fromJson(data);
    } catch (e) {
      throw mapSupabaseError(e);
    }
  }
}
