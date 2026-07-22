import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/extensions/theme_extension.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/events/presentation/utils/event_formatters.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_summary.dart';
import 'package:eventix/features/reservations/presentation/widgets/reservation_status_badge.dart';
import 'package:flutter/material.dart';

class ReservationCard extends StatelessWidget {
  const ReservationCard({
    required this.reservation,
    required this.onTap,
    super.key,
  });

  final ReservationSummary reservation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return AppListItemCard(
      imageUrl: reservation.eventoImagenUrl,
      onTap: onTap,
      trailing: ReservationStatusBadge(estado: reservation.estado),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            reservation.eventoTitulo,
            style: AppTypography.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            formatEventFecha(reservation.eventoFecha),
            style: AppTypography.bodySmall.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${reservation.cantidadEntradas} '
            '${l10n.reservations_entradas_suffix} · '
            '${formatEventPrecio(reservation.total)}',
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
