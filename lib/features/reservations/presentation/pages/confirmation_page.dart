import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/extensions/theme_extension.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/events/presentation/pages/events_page.dart';
import 'package:eventix/features/events/presentation/utils/event_formatters.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:eventix/features/reservations/presentation/pages/reservations_page.dart';
import 'package:eventix/features/reservations/presentation/providers/reservation_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConfirmationPage extends ConsumerWidget {
  static const String routePath = '/checkout/:reservationId/confirmation';

  const ConfirmationPage({required this.reservationId, super.key});

  final String reservationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ReservationDetail> asyncReservation = ref.watch(
      reservationDetailProvider(reservationId),
    );
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: context.colorScheme.secondary,
      body: Theme(
        data: AppTheme.dark(),
        child: Builder(
          builder: (BuildContext context) => SafeArea(
            child: asyncReservation.when(
              loading: () => const Center(
                child: AppLoader(size: AppLoaderSize.large),
              ),
              error: (Object error, _) => AppErrorState(
                message: switch (error) {
                  Failure(:final String userMessage) => userMessage,
                  _ => l10n.common_unexpected_error,
                },
                onRetry: () =>
                    ref.invalidate(reservationDetailProvider(reservationId)),
              ),
              data: (ReservationDetail reservation) => Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: context.appSemanticColors.success.withValues(
                            alpha: 0.15,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: context.appSemanticColors.success,
                          size: 56,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      l10n.confirmation_title,
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.confirmation_subtitle(reservation.eventoTitulo),
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    AppCard(
                      variant: AppCardVariant.filled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                l10n.confirmation_tickets_label,
                                style: AppTypography.bodyMedium,
                              ),
                              Text(
                                '${reservation.cantidadEntradas}',
                                style: AppTypography.labelLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                l10n.confirmation_total_label,
                                style: AppTypography.bodyMedium,
                              ),
                              Text(
                                formatEventPrecio(reservation.total),
                                style: AppTypography.titleMedium.copyWith(
                                  color: context.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    AppButton(
                      label: l10n.confirmation_view_reservations,
                      isFullWidth: true,
                      onPressed: () => context.go(ReservationsPage.routePath),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: l10n.confirmation_back_home,
                      variant: AppButtonVariant.outlined,
                      isFullWidth: true,
                      onPressed: () => context.go(EventsPage.routePath),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
