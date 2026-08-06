import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/config/app_config.dart';
import 'package:eventix/core/config/app_config_provider.dart';
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
    final AppConfig config = ref.watch(appConfigProvider).requireValue;

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
                    const Center(
                      child: AppStatusIcon(
                        icon: Icons.check_circle,
                        variant: AppStatusBadgeVariant.success,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      config.confirmacion.titulo,
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      config.confirmacion.subtituloPara(
                        reservation.eventoTitulo,
                      ),
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
                          AppKeyValueRow(
                            label: config.confirmacion.entradasLabel,
                            value: '${reservation.cantidadEntradas}',
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          AppKeyValueRow(
                            label: config.confirmacion.totalLabel,
                            value: formatEventPrecio(reservation.total),
                            emphasize: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    AppButton(
                      label: config.confirmacion.botonVerReservas,
                      isFullWidth: true,
                      onPressed: () => context.go(ReservationsPage.routePath),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: config.confirmacion.botonVolverInicio,
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
