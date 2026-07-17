import 'package:eventix/core/errors/supabase_error_mapper.dart';
import 'package:eventix/features/events/domain/entities/event_filter.dart';
import 'package:eventix/features/events/infrastructure/remote/remote_event_datasource.dart';
import 'package:eventix/features/events/infrastructure/remote/supabase/models/remote_event_model.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseEventDatasource implements EventRemoteDatasource {
  const SupabaseEventDatasource(this._client);

  final SupabaseClient _client;

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Future<List<RemoteEventModel>> getEvents({EventFilter? filter}) async {
    try {
      PostgrestFilterBuilder<List<Map<String, dynamic>>> query = _client
          .from('events')
          .select();

      if (filter?.categoria != null) {
        query = query.eq('categoria', filter!.categoria!);
      }
      if (filter?.ciudad != null) {
        query = query.eq('ciudad', filter!.ciudad!);
      }
      if (filter?.fecha != null) {
        query = query.eq('fecha', _dateFormat.format(filter!.fecha!));
      }
      if (filter?.query != null && filter!.query!.trim().isNotEmpty) {
        query = query.ilike('titulo', '%${filter.query!.trim()}%');
      }

      final List<Map<String, dynamic>> data = await query.order(
        'fecha',
        ascending: true,
      );
      return data.map(RemoteEventModel.fromJson).toList();
    } catch (e) {
      throw mapSupabaseError(e);
    }
  }

  @override
  Future<RemoteEventModel> getEventById(String id) async {
    try {
      final Map<String, dynamic> data = await _client
          .from('events')
          .select()
          .eq('id', id)
          .single();
      return RemoteEventModel.fromJson(data);
    } catch (e) {
      throw mapSupabaseError(e);
    }
  }
}
