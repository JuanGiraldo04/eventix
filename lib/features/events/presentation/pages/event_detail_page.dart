import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/events/domain/entities/event.dart';
import 'package:eventix/features/events/presentation/providers/event_detail_provider.dart';
import 'package:eventix/features/events/presentation/utils/event_formatters.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/presentation/providers/create_reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EventDetailPage extends ConsumerWidget {
  static const String routePath = '/events/:id';

  const EventDetailPage({required this.eventId, super.key});
  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Event> asyncEvent = ref.watch(
      eventDetailProvider(eventId),
    );
    final AppLocalizations l10n = AppLocalizations.of(context);

    return asyncEvent.when(
      loading: () => const Scaffold(
        body: Center(child: AppLoader(size: AppLoaderSize.large)),
      ),
      error: (Object error, _) => Scaffold(
        appBar: AppBar(),
        body: AppErrorState(
          message: switch (error) {
            Failure(:final String userMessage) => userMessage,
            _ => l10n.common_unexpected_error,
          },
          onRetry: () => ref.invalidate(eventDetailProvider(eventId)),
        ),
      ),
      data: (Event event) => _EventDetailScaffold(event: event, l10n: l10n),
    );
  }
}

class _EventDetailScaffold extends ConsumerWidget {
  const _EventDetailScaffold({required this.event, required this.l10n});

  final Event event;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Reservation?> asyncReservation = ref.watch(
      reservationCreationProvider,
    );

    ref.listen(reservationCreationProvider, (
      AsyncValue<Reservation?>? previous,
      AsyncValue<Reservation?> next,
    ) async {
      final Reservation? reservation = next.value;
      if (reservation != null) {
        await context.push('/checkout/${reservation.id}');
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppDetailHeroImage(
              imageUrl: event.imagenUrl,
              onBack: () => context.pop(),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      AppChip(label: event.categoria, isSelected: true),
                      const SizedBox(width: AppSpacing.sm),
                      AppChip(label: event.ciudad),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(event.titulo, style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.md),
                  AppMetaRow(
                    items: <AppMetaItem>[
                      AppMetaItem(
                        icon: Icons.calendar_today_outlined,
                        label:
                            '${formatEventFecha(event.fecha)} · '
                            '${event.hora}',
                      ),
                      AppMetaItem(
                        icon: Icons.location_on_outlined,
                        label: event.ciudad,
                        expanded: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppProgressStat(
                    label: l10n.event_detail_available_spots,
                    value: '${event.cuposDisponibles} / ${event.capacidad}',
                    progress: event.capacidad == 0
                        ? 0
                        : event.cuposDisponibles / event.capacidad,
                    variant: eventCuposVariant(
                      event.cuposDisponibles,
                      event.capacidad,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.event_detail_description,
                    style: AppTypography.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(event.descripcion, style: AppTypography.bodyMedium),
                  const SizedBox(height: AppSpacing.lg),
                  AppKeyValueRow(
                    label: l10n.event_detail_price_prefix,
                    value:
                        '${formatEventPrecio(event.precio)} '
                        '${l10n.event_detail_price_suffix}',
                    emphasize: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomActionBar(
        buttonLabel: event.tieneCupos
            ? l10n.event_detail_reserve
            : l10n.event_detail_sold_out,
        isLoading: asyncReservation.isLoading,
        errorMessage: asyncReservation.hasError
            ? switch (asyncReservation.error) {
                Failure(:final String userMessage) => userMessage,
                _ => l10n.common_unexpected_error,
              }
            : null,
        onPressed: event.tieneCupos
            ? () => ref
                  .read(reservationCreationProvider.notifier)
                  .create(
                    eventoId: event.id,
                    cantidadEntradas: 1,
                    total: event.precio,
                  )
            : null,
      ),
    );
  }
}
