import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';

abstract interface class AuthRepository {
  Future<Result<AppUser>> login({
    required String email,
    required String password,
  });

  Future<Result<AppUser>> register({
    required String nombre,
    required String email,
    required String password,
  });

  Future<Result<void>> logout();

  Future<Result<AppUser>> getCurrentUser();
}
