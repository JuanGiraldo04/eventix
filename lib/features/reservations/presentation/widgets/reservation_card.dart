import 'package:app_ui_kit/app_ui_kit.dart';
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
      title: reservation.eventoTitulo,
      titleMaxLines: 1,
      subtitleLines: <String>[formatEventFecha(reservation.eventoFecha)],
      detailLine:
          '${reservation.cantidadEntradas} '
          '${l10n.reservations_entradas_suffix} · '
          '${formatEventPrecio(reservation.total)}',
      trailing: ReservationStatusBadge(estado: reservation.estado),
      onTap: onTap,
    );
  }
}
