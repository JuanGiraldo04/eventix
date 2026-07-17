import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/errors/supabase_error_mapper.dart';
import 'package:eventix/features/auth/infrastructure/remote/remote_auth_datasource.dart';
import 'package:eventix/features/auth/infrastructure/remote/supabase/models/remote_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthDatasource implements AuthRemoteDatasource {
  const SupabaseAuthDatasource(this._client);

  final SupabaseClient _client;

  @override
  Future<RemoteUserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return _fetchUserModel(response.user);
    } catch (e) {
      throw mapSupabaseError(e);
    }
  }

  @override
  Future<RemoteUserModel> register({
    required String nombre,
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signUp(
        email: email,
        password: password,
        data: <String, dynamic>{'nombre': nombre},
      );
      if (response.session == null) {
        throw const ServerFailure(
          'Revisa tu correo para confirmar la cuenta antes de continuar',
        );
      }
      return _fetchUserModel(response.user);
    } catch (e) {
      if (e is Failure) rethrow;
      throw mapSupabaseError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw mapSupabaseError(e);
    }
  }

  @override
  Future<RemoteUserModel> getCurrentUser() async {
    try {
      return await _fetchUserModel(_client.auth.currentUser);
    } catch (e) {
      if (e is Failure) rethrow;
      throw mapSupabaseError(e);
    }
  }

  Future<RemoteUserModel> _fetchUserModel(User? user) async {
    if (user == null) {
      throw const UnexpectedFailure('No se pudo obtener el usuario');
    }
    final Map<String, dynamic> profile = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
    return RemoteUserModel.fromJson(<String, dynamic>{
      ...profile,
      'email': user.email,
    });
  }
}
