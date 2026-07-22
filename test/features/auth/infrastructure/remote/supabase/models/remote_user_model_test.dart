import 'package:eventix/features/auth/infrastructure/remote/supabase/models/remote_user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteUserModel.fromJson', () {
    test(
      'given a full json payload '
      'when fromJson is called '
      'then returns a RemoteUserModel with every field mapped',
      () {
        final RemoteUserModel model = RemoteUserModel.fromJson(
          const <String, dynamic>{
            'id': 'user-1',
            'email': 'juan@example.com',
            'nombre': 'Juan Giraldo',
            'avatar_url': 'https://example.com/avatar.png',
          },
        );

        expect(model.id, 'user-1');
        expect(model.email, 'juan@example.com');
        expect(model.nombre, 'Juan Giraldo');
        expect(model.avatarUrl, 'https://example.com/avatar.png');
      },
    );

    test(
      'given a json payload with no avatar_url '
      'when fromJson is called '
      'then avatarUrl is null',
      () {
        final RemoteUserModel model = RemoteUserModel.fromJson(
          const <String, dynamic>{
            'id': 'user-1',
            'email': 'juan@example.com',
            'nombre': 'Juan Giraldo',
            'avatar_url': null,
          },
        );

        expect(model.avatarUrl, isNull);
      },
    );
  });
}
