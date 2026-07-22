import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/extensions/theme_extension.dart';
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
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 4 / 3,
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
                            size: 48,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
                  left: AppSpacing.lg,
                  child: AppCircleIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => context.pop(),
                  ),
                ),
              ],
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
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${formatEventFecha(event.fecha)} · ${event.hora}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        event.ciudad,
                        style: AppTypography.bodyMedium.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        '${l10n.event_detail_price_prefix} ',
                        style: AppTypography.bodyMedium.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        formatEventPrecio(event.precio),
                        style: AppTypography.headlineSmall.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                      Text(
                        ' ${l10n.event_detail_price_suffix}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (asyncReservation.hasError) ...<Widget>[
                AppBanner(
                  variant: AppBannerVariant.error,
                  message: switch (asyncReservation.error) {
                    Failure(:final String userMessage) => userMessage,
                    _ => l10n.common_unexpected_error,
                  },
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              AppButton(
                label: event.tieneCupos
                    ? l10n.event_detail_reserve
                    : l10n.event_detail_sold_out,
                isFullWidth: true,
                isLoading: asyncReservation.isLoading,
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
            ],
          ),
        ),
      ),
    );
  }
}
