import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/extensions/theme_extension.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/presentation/utils/event_formatters.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({required this.event, required this.onTap, super.key});

  final Event event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AppStatusBadgeVariant cuposVariant = eventCuposVariant(
      event.cuposDisponibles,
      event.capacidad,
    );

    return AppMediaCard(
      imageUrl: event.imagenUrl,
      onTap: onTap,
      overlay: AppChip(label: event.categoria, isSelected: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            event.titulo,
            style: AppTypography.titleSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: <Widget>[
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.ciudad,
                  style: AppTypography.bodySmall.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                formatEventFecha(event.fecha),
                style: AppTypography.bodySmall.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                formatEventPrecio(event.precio),
                style: AppTypography.titleMedium.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
              AppStatusBadge(
                label: '${event.cuposDisponibles} ${l10n.events_spots_suffix}',
                variant: cuposVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
