import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/infrastructure/remote/supabase/mappers/remote_user_mapper.dart';
import 'package:eventix/features/auth/infrastructure/remote/supabase/models/remote_user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteUserMapper.toEntity', () {
    test(
      'given a RemoteUserModel '
      'when toEntity is called '
      'then returns an AppUser with the same field values',
      () {
        const RemoteUserModel model = RemoteUserModel(
          id: 'user-1',
          email: 'juan@example.com',
          nombre: 'Juan Giraldo',
          avatarUrl: 'https://example.com/avatar.png',
        );

        final AppUser user = RemoteUserMapper.toEntity(model);

        expect(user.id, model.id);
        expect(user.email, model.email);
        expect(user.nombre, model.nombre);
        expect(user.avatarUrl, model.avatarUrl);
      },
    );
  });
}
