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
    final Color cuposColor = eventCuposColor(
      context,
      event.cuposDisponibles,
      event.capacidad,
    );

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
            child: Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    event.imagenUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) => ColoredBox(
                          color: context.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                  ),
                ),
                Positioned(
                  top: AppSpacing.sm,
                  left: AppSpacing.sm,
                  child: AppChip(label: event.categoria, isSelected: true),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: cuposColor.withValues(alpha: 0.12),
                        borderRadius: AppRadius.fullBorderRadius,
                      ),
                      child: Text(
                        '${event.cuposDisponibles} ${l10n.events_spots_suffix}',
                        style: AppTypography.labelSmall.copyWith(
                          color: cuposColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
