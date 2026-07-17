import 'dart:async';

import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/di/auth_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logout_provider.g.dart';

@riverpod
class LogoutNotifier extends _$LogoutNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> logout() async {
    state = const AsyncLoading<void>();
    final Result<void> result = await ref.read(logoutUserProvider).call();
    if (!ref.mounted) return;
    state = switch (result) {
      Success<void>() => const AsyncData<void>(null),
      FailureResult<void>(:final Failure failure) => AsyncError<void>(
        failure,
        StackTrace.current,
      ),
    };
  }
}
