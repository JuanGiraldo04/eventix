import 'package:eventix/core/helpers/execute_repository_call.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/domain/repositories/auth_repository.dart';
import 'package:eventix/features/auth/infrastructure/remote/remote_auth_datasource.dart';
import 'package:eventix/features/auth/infrastructure/remote/supabase/mappers/remote_user_mapper.dart';
import 'package:eventix/features/auth/infrastructure/remote/supabase/models/remote_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDatasource);

  final AuthRemoteDatasource _remoteDatasource;

  @override
  Future<Result<AppUser>> login({
    required String email,
    required String password,
  }) {
    return executeRepositoryCall(() async {
      final RemoteUserModel model = await _remoteDatasource.login(
        email: email,
        password: password,
      );
      return RemoteUserMapper.toEntity(model);
    });
  }

  @override
  Future<Result<AppUser>> register({
    required String nombre,
    required String email,
    required String password,
  }) {
    return executeRepositoryCall(() async {
      final RemoteUserModel model = await _remoteDatasource.register(
        nombre: nombre,
        email: email,
        password: password,
      );
      return RemoteUserMapper.toEntity(model);
    });
  }

  @override
  Future<Result<void>> logout() {
    return executeRepositoryCall(() => _remoteDatasource.logout());
  }

  @override
  Future<Result<AppUser>> getCurrentUser() {
    return executeRepositoryCall(() async {
      final RemoteUserModel model = await _remoteDatasource.getCurrentUser();
      return RemoteUserMapper.toEntity(model);
    });
  }
}
