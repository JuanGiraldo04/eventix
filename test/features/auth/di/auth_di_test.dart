import 'package:eventix/core/services/supabase/supabase_provider.dart';
import 'package:eventix/features/auth/di/auth_di.dart';
import 'package:eventix/features/auth/domain/usecases/get_current_user.dart';
import 'package:eventix/features/auth/domain/usecases/login_user.dart';
import 'package:eventix/features/auth/domain/usecases/logout_user.dart';
import 'package:eventix/features/auth/domain/usecases/register_user.dart';
import 'package:eventix/features/auth/infrastructure/remote/supabase/datasource/supabase_auth_datasource.dart';
import 'package:eventix/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/src/framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test(
    'given a SupabaseClient override '
    'when the auth DI providers are read '
    'then each one resolves the expected concrete type',
    () {
      final SupabaseClient client = SupabaseClient(
        'https://example.supabase.co',
        'anon-key',
      );
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          supabaseClientProvider.overrideWithValue(client),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(authRemoteDatasourceProvider),
        isA<SupabaseAuthDatasource>(),
      );
      expect(
        container.read(authRepositoryProvider),
        isA<AuthRepositoryImpl>(),
      );
      expect(container.read(loginUserProvider), isA<LoginUser>());
      expect(container.read(registerUserProvider), isA<RegisterUser>());
      expect(container.read(logoutUserProvider), isA<LogoutUser>());
      expect(container.read(getCurrentUserProvider), isA<GetCurrentUser>());
    },
  );
}
