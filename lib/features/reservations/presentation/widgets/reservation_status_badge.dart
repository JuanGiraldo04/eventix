import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/extensions/theme_extension.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:flutter/material.dart';

class ReservationStatusBadge extends StatelessWidget {
  const ReservationStatusBadge({required this.estado, super.key});

  final String estado;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final (Color color, String label) = switch (estado) {
      kReservationConfirmada => (
        context.appSemanticColors.success,
        l10n.reservation_status_confirmada,
      ),
      kReservationPendiente => (
        context.appSemanticColors.warning,
        l10n.reservation_status_pendiente,
      ),
      _ => (context.colorScheme.error, l10n.reservation_status_cancelada),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.fullBorderRadius,
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }
}
