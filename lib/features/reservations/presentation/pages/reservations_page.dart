import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/domain/entities/reservation_summary.dart';
import 'package:eventix/features/reservations/presentation/providers/my_reservations_provider.dart';
import 'package:eventix/features/reservations/presentation/widgets/reservation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReservationsPage extends ConsumerWidget {
  static const String routePath = '/reservations';

  const ReservationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ReservationSummary>> asyncReservations = ref.watch(
      myReservationsProvider,
    );
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reservations_title)),
      body: asyncReservations.when(
        loading: () =>
            const Center(child: AppLoader(size: AppLoaderSize.large)),
        error: (Object error, _) => AppErrorState(
          message: switch (error) {
            Failure(:final String userMessage) => userMessage,
            _ => l10n.reservations_error_message,
          },
          onRetry: () => ref.invalidate(myReservationsProvider),
        ),
        data: (List<ReservationSummary> reservations) {
          if (reservations.isEmpty) {
            return AppEmptyState(
              title: l10n.reservations_empty_title,
              message: l10n.reservations_empty_message,
            );
          }

          final List<ReservationSummary> confirmadas = reservations
              .where(
                (ReservationSummary r) => r.estado == kReservationConfirmada,
              )
              .toList();
          final List<ReservationSummary> pendientes = reservations
              .where(
                (ReservationSummary r) => r.estado == kReservationPendiente,
              )
              .toList();

          return RefreshIndicator(
            onRefresh: () => ref.refresh(myReservationsProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: <Widget>[
                if (confirmadas.isNotEmpty) ...<Widget>[
                  Text(
                    l10n.reservations_confirmed_section,
                    style: AppTypography.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final ReservationSummary r in confirmadas)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: ReservationCard(
                        reservation: r,
                        onTap: () => context.push('/reservations/${r.id}'),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (pendientes.isNotEmpty) ...<Widget>[
                  Text(
                    l10n.reservations_pending_section,
                    style: AppTypography.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final ReservationSummary r in pendientes)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: ReservationCard(
                        reservation: r,
                        onTap: () => context.push('/reservations/${r.id}'),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
