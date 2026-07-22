import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/errors/failure.dart';
import 'package:eventix/core/extensions/theme_extension.dart';
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
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.event.titulo,
                        style: AppTypography.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${formatEventFecha(data.event.fecha)} · '
                        '${data.event.hora}',
                        style: AppTypography.bodySmall.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      l10n.checkout_quantity_label,
                      style: AppTypography.bodyMedium,
                    ),
                    AppStepper(
                      value: quantity,
                      onDecrement: quantity > 1
                          ? () => ref
                                .read(
                                  checkoutQuantityProvider(
                                    reservationId,
                                  ).notifier,
                                )
                                .decrement()
                          : null,
                      onIncrement: quantity < maxQuantity
                          ? () => ref
                                .read(
                                  checkoutQuantityProvider(
                                    reservationId,
                                  ).notifier,
                                )
                                .increment(maxQuantity)
                          : null,
                    ),
                  ],
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
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (asyncConfirm.hasError) ...<Widget>[
                  AppBanner(
                    variant: AppBannerVariant.error,
                    message: switch (asyncConfirm.error) {
                      Failure(:final String userMessage) => userMessage,
                      _ => l10n.common_unexpected_error,
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                AppButton(
                  label: l10n.checkout_confirm,
                  isFullWidth: true,
                  isLoading: asyncConfirm.isLoading,
                  onPressed: () => ref
                      .read(confirmPurchaseProvider.notifier)
                      .confirmPurchase(
                        reservationId: reservationId,
                        cantidadEntradas: quantity,
                        total: total,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
