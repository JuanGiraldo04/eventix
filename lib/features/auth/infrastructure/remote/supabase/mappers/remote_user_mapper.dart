import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/infrastructure/remote/supabase/models/remote_user_model.dart';

class RemoteUserMapper {
  const RemoteUserMapper._();

  static AppUser toEntity(RemoteUserModel model) => AppUser(
    id: model.id,
    email: model.email,
    nombre: model.nombre,
    avatarUrl: model.avatarUrl,
  );
}
