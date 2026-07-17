import 'package:eventix/features/auth/infrastructure/remote/supabase/models/remote_user_model.dart';

abstract interface class AuthRemoteDatasource {
  Future<RemoteUserModel> login({
    required String email,
    required String password,
  });

  Future<RemoteUserModel> register({
    required String nombre,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<RemoteUserModel> getCurrentUser();
}
