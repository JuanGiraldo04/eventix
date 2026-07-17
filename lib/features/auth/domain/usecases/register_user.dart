import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/domain/repositories/auth_repository.dart';

class RegisterUser {
  const RegisterUser(this._repository);

  final AuthRepository _repository;

  Future<Result<AppUser>> call({
    required String nombre,
    required String email,
    required String password,
  }) => _repository.register(nombre: nombre, email: email, password: password);
}
