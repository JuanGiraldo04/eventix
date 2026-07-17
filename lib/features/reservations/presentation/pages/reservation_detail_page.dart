import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/extensions/theme_extension.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/events/presentation/utils/event_formatters.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_detail.dart';
import 'package:eventix/features/reservations/domain/entities/ticket.dart';
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
              AppCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: AppRadius.mdBorderRadius,
                      child: Image.network(
                        detail.eventoImagenUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) => Container(
                              width: 64,
                              height: 64,
                              color:
                                  context.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
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
                    ReservationStatusBadge(estado: detail.estado),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                variant: AppCardVariant.filled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _InfoRow(
                      label: l10n.reservation_detail_entradas_label,
                      value:
                          '${detail.cantidadEntradas} '
                          '${l10n.reservations_entradas_suffix}',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _InfoRow(
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
                    child: _TicketCard(
                      ticket: detail.tickets[i],
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: AppTypography.bodyMedium),
        Text(value, style: AppTypography.labelLarge),
      ],
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.label});

  final Ticket ticket;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => _showEnlargedQr(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                ticket.codigo,
                style: AppTypography.titleMedium.copyWith(letterSpacing: 2),
              ),
            ],
          ),
          Icon(Icons.qr_code_2, size: 32, color: context.colorScheme.primary),
        ],
      ),
    );
  }

  Future<void> _showEnlargedQr(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Icon(
                Icons.qr_code_2,
                size: 220,
                color: context.colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                ticket.codigo,
                style: AppTypography.titleMedium.copyWith(letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
