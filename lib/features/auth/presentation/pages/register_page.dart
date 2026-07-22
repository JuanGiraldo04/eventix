import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/extensions/theme_extension.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/auth/domain/entities/app_user.dart';
import 'package:eventix/features/auth/presentation/pages/login_page.dart';
import 'package:eventix/features/auth/presentation/providers/register_provider.dart';
import 'package:eventix/features/auth/presentation/widgets/eventix_logo.dart';
import 'package:eventix/features/events/presentation/pages/events_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends ConsumerWidget {
  static const String routePath = '/register';

  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppUser?> asyncUser = ref.watch(registerProvider);
    final AppLocalizations l10n = AppLocalizations.of(context);

    ref.listen(registerProvider, (
      AsyncValue<AppUser?>? previous,
      AsyncValue<AppUser?> next,
    ) {
      final AppUser? user = next.value;
      if (user != null) context.go(EventsPage.routePath);
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Center(child: EventixLogo()),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.register_title,
                textAlign: TextAlign.center,
                style: AppTypography.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.register_tagline,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              if (asyncUser.hasError) ...<Widget>[
                AppBanner(
                  variant: AppBannerVariant.error,
                  title: l10n.register_title,
                  message: switch (asyncUser.error) {
                    Failure(:final String userMessage) => userMessage,
                    _ => l10n.common_unexpected_error,
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              _RegisterForm(
                isLoading: asyncUser.isLoading,
                onSubmit: (String nombre, String email, String password) => ref
                    .read(registerProvider.notifier)
                    .register(nombre: nombre, email: email, password: password),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    l10n.register_have_account_prompt,
                    style: AppTypography.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () => context.go(LoginPage.routePath),
                    child: Text(l10n.register_go_login),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({required this.isLoading, required this.onSubmit});

  final bool isLoading;
  final void Function(String nombre, String email, String password) onSubmit;

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppTextField(
          label: l10n.register_name_label,
          leading: const Icon(Icons.person_outline),
          controller: _nombreController,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.login_email_label,
          hint: l10n.login_email_hint,
          leading: const Icon(Icons.email_outlined),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.login_password_label,
          leading: const Icon(Icons.lock_outline),
          isPassword: true,
          controller: _passwordController,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: l10n.register_submit,
          isLoading: widget.isLoading,
          isFullWidth: true,
          onPressed: () => widget.onSubmit(
            _nombreController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
          ),
        ),
      ],
    );
  }
}
