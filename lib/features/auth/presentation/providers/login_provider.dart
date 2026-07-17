import 'dart:async';

import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/di/auth_di.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_provider.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  FutureOr<AppUser?> build() => null;

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading<AppUser?>();
    final Result<AppUser> result = await ref
        .read(loginUserProvider)
        .call(email: email, password: password);
    if (!ref.mounted) return;
    state = switch (result) {
      Success<AppUser>(:final AppUser data) => AsyncData<AppUser?>(data),
      FailureResult<AppUser>(:final Failure failure) => AsyncError<AppUser?>(
        failure,
        StackTrace.current,
      ),
    };
  }
}
