import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:eventix/features/events/presentation/utils/event_formatters.dart';
import 'package:eventix/features/reservations/domain/entities/reservation.dart';
import 'package:eventix/features/reservations/presentation/providers/checkout_provider.dart';
import 'package:eventix/features/reservations/presentation/providers/checkout_quantity_provider.dart';
import 'package:eventix/features/reservations/presentation/providers/confirm_purchase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CheckoutPage extends ConsumerWidget {
  static const String routePath = '/checkout/:reservationId';

  const CheckoutPage({required this.reservationId, super.key});

  final String reservationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CheckoutData> asyncCheckout = ref.watch(
      checkoutProvider(reservationId),
    );
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkout_title)),
      body: asyncCheckout.when(
        loading: () =>
            const Center(child: AppLoader(size: AppLoaderSize.large)),
        error: (Object error, _) => AppErrorState(
          message: switch (error) {
            Failure(:final String userMessage) => userMessage,
            _ => l10n.common_unexpected_error,
          },
          onRetry: () => ref.invalidate(checkoutProvider(reservationId)),
        ),
        data: (CheckoutData data) => _CheckoutBody(
          reservationId: reservationId,
          data: data,
          l10n: l10n,
        ),
      ),
    );
  }
}

class _CheckoutBody extends ConsumerWidget {
  const _CheckoutBody({
    required this.reservationId,
    required this.data,
    required this.l10n,
  });

  final String reservationId;
  final CheckoutData data;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int quantity = ref.watch(checkoutQuantityProvider(reservationId));
    final int maxQuantity = data.event.cuposDisponibles < 10
        ? data.event.cuposDisponibles
        : 10;
    final double total = data.event.precio * quantity;
    final AsyncValue<Reservation?> asyncConfirm = ref.watch(
      confirmPurchaseProvider,
    );

    ref.listen(confirmPurchaseProvider, (
      AsyncValue<Reservation?>? previous,
      AsyncValue<Reservation?> next,
    ) {
      final Reservation? reservation = next.value;
      if (reservation != null) {
        context.pushReplacement('/checkout/$reservationId/confirmation');
      }
    });

    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AppListItemCard(
                  imageUrl: data.event.imagenUrl,
                  title: data.event.titulo,
                  titleMaxLines: 2,
                  subtitleLines: <String>[
                    '${formatEventFecha(data.event.fecha)} · '
                        '${data.event.hora}',
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppStepper(
                  label: l10n.checkout_quantity_label,
                  value: quantity,
                  onDecrement: quantity > 1
                      ? () => ref
                            .read(
                              checkoutQuantityProvider(reservationId).notifier,
                            )
                            .decrement()
                      : null,
                  onIncrement: quantity < maxQuantity
                      ? () => ref
                            .read(
                              checkoutQuantityProvider(reservationId).notifier,
                            )
                            .increment(maxQuantity)
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppKeyValueRow(
                  label: l10n.checkout_price_per_ticket,
                  value: formatEventPrecio(data.event.precio),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  variant: AppCardVariant.filled,
                  child: AppKeyValueRow(
                    label: l10n.checkout_total_label,
                    value: formatEventPrecio(total),
                    emphasize: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        AppBottomActionBar(
          buttonLabel: l10n.checkout_confirm,
          isLoading: asyncConfirm.isLoading,
          errorMessage: asyncConfirm.hasError
              ? switch (asyncConfirm.error) {
                  Failure(:final String userMessage) => userMessage,
                  _ => l10n.common_unexpected_error,
                }
              : null,
          onPressed: () => ref
              .read(confirmPurchaseProvider.notifier)
              .confirmPurchase(
                reservationId: reservationId,
                cantidadEntradas: quantity,
                total: total,
              ),
        ),
      ],
    );
  }
}
