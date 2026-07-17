import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/extensions/theme_extension.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/presentation/providers/current_user_provider.dart';
import 'package:eventix/features/auth/presentation/providers/logout_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  static const String routePath = '/profile';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppUser> asyncUser = ref.watch(currentUserProvider);
    final AsyncValue<void> asyncLogout = ref.watch(logoutProvider);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile_title)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppCard(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: context.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: asyncUser.when(
                      loading: () => const AppLoader(),
                      error: (Object error, _) => Text(
                        switch (error) {
                          Failure(:final String userMessage) => userMessage,
                          _ => l10n.common_unexpected_error,
                        },
                        style: AppTypography.bodyMedium,
                      ),
                      data: (AppUser user) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(user.nombre, style: AppTypography.titleMedium),
                          Text(
                            user.email,
                            style: AppTypography.bodySmall.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (asyncLogout.hasError)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: AppBanner(
                  variant: AppBannerVariant.error,
                  message: switch (asyncLogout.error) {
                    Failure(:final String userMessage) => userMessage,
                    _ => l10n.common_unexpected_error,
                  },
                ),
              ),
            AppButton(
              label: l10n.profile_logout,
              variant: AppButtonVariant.outlined,
              isFullWidth: true,
              isLoading: asyncLogout.isLoading,
              onPressed: () => ref.read(logoutProvider.notifier).logout(),
            ),
          ],
        ),
      ),
    );
  }
}
