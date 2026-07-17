import 'package:eventix/core/services/supabase/supabase_provider.dart';
import 'package:eventix/features/auth/domain/usecases/get_current_user.dart';
import 'package:eventix/features/auth/domain/usecases/login_user.dart';
import 'package:eventix/features/auth/domain/usecases/logout_user.dart';
import 'package:eventix/features/auth/domain/usecases/register_user.dart';
import 'package:eventix/features/auth/infrastructure/remote/supabase/datasource/supabase_auth_datasource.dart';
import 'package:eventix/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_di.g.dart';

@riverpod
SupabaseAuthDatasource authRemoteDatasource(Ref ref) =>
    SupabaseAuthDatasource(ref.watch(supabaseClientProvider));

@riverpod
AuthRepositoryImpl authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(authRemoteDatasourceProvider));

@riverpod
LoginUser loginUser(Ref ref) => LoginUser(ref.watch(authRepositoryProvider));

@riverpod
RegisterUser registerUser(Ref ref) =>
    RegisterUser(ref.watch(authRepositoryProvider));

@riverpod
LogoutUser logoutUser(Ref ref) => LogoutUser(ref.watch(authRepositoryProvider));

@riverpod
GetCurrentUser getCurrentUser(Ref ref) =>
    GetCurrentUser(ref.watch(authRepositoryProvider));
