import 'package:app_ui_kit/app_ui_kit.dart';
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

    return AppEventCard(
      imageUrl: event.imagenUrl,
      categoryLabel: event.categoria,
      title: event.titulo,
      metaItems: <AppMetaItem>[
        AppMetaItem(
          icon: Icons.location_on_outlined,
          label: event.ciudad,
          expanded: true,
        ),
        AppMetaItem(
          icon: Icons.calendar_today_outlined,
          label: formatEventFecha(event.fecha),
        ),
      ],
      priceLabel: formatEventPrecio(event.precio),
      spotsLabel: '${event.cuposDisponibles} ${l10n.events_spots_suffix}',
      spotsVariant: eventCuposVariant(
        event.cuposDisponibles,
        event.capacidad,
      ),
      onTap: onTap,
    );
  }
}
