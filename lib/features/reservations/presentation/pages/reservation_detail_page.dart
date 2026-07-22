import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/extensions/theme_extension.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/events/presentation/utils/event_formatters.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:eventix/features/reservations/presentation/providers/reservation_detail_provider.dart';
import 'package:eventix/features/reservations/presentation/widgets/reservation_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReservationDetailPage extends ConsumerWidget {
  static const String routePath = '/reservations/:id';

  const ReservationDetailPage({required this.reservationId, super.key});

  final String reservationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ReservationDetail> asyncDetail = ref.watch(
      reservationDetailProvider(reservationId),
    );
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reservation_detail_title)),
      body: asyncDetail.when(
        loading: () =>
            const Center(child: AppLoader(size: AppLoaderSize.large)),
        error: (Object error, _) => AppErrorState(
          message: switch (error) {
            Failure(:final String userMessage) => userMessage,
            _ => l10n.common_unexpected_error,
          },
          onRetry: () =>
              ref.invalidate(reservationDetailProvider(reservationId)),
        ),
        data: (ReservationDetail detail) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppListItemCard(
                imageUrl: detail.eventoImagenUrl,
                imageSize: 64,
                trailing: ReservationStatusBadge(estado: detail.estado),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      detail.eventoTitulo,
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${formatEventFecha(detail.eventoFecha)} · '
                      '${detail.eventoHora}',
                      style: AppTypography.bodySmall.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      detail.eventoCiudad,
                      style: AppTypography.bodySmall.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                variant: AppCardVariant.filled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    AppKeyValueRow(
                      label: l10n.reservation_detail_entradas_label,
                      value:
                          '${detail.cantidadEntradas} '
                          '${l10n.reservations_entradas_suffix}',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppKeyValueRow(
                      label: l10n.reservation_detail_total_label,
                      value: formatEventPrecio(detail.total),
                    ),
                  ],
                ),
              ),
              if (detail.tickets.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.xl),
                Text(
                  l10n.reservation_detail_tickets_section,
                  style: AppTypography.titleSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                for (int i = 0; i < detail.tickets.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppTicketCard(
                      code: detail.tickets[i].codigo,
                      label: l10n.reservation_detail_ticket_label(
                        i + 1,
                        detail.tickets.length,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
