import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/helpers/result.dart';
import 'package:eventix/features/auth/di/auth_di.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_provider.g.dart';

@riverpod
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  Future<AppUser> build() async {
    final Result<AppUser> result = await ref
        .watch(getCurrentUserProvider)
        .call();
    return switch (result) {
      Success<AppUser>(:final AppUser data) => data,
      FailureResult<AppUser>(:final Failure failure) => throw failure,
    };
  }
}
