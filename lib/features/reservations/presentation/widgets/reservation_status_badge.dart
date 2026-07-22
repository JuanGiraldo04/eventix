import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:flutter/material.dart';

class ReservationStatusBadge extends StatelessWidget {
  const ReservationStatusBadge({required this.estado, super.key});

  final String estado;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final (AppStatusBadgeVariant variant, String label) = switch (estado) {
      kReservationConfirmada => (
        AppStatusBadgeVariant.success,
        l10n.reservation_status_confirmada,
      ),
      kReservationPendiente => (
        AppStatusBadgeVariant.warning,
        l10n.reservation_status_pendiente,
      ),
      _ => (AppStatusBadgeVariant.error, l10n.reservation_status_cancelada),
    };

    return AppStatusBadge(label: label, variant: variant);
  }
}
