import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/config/app_config.dart';
import 'package:eventix/core/config/app_config_provider.dart';
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
    final AppConfig config = ref.watch(appConfigProvider).requireValue;

    return Scaffold(
      appBar: AppBar(title: Text(config.checkout.titulo)),
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
          config: config,
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
    required this.config,
  });

  final String reservationId;
  final CheckoutData data;
  final AppLocalizations l10n;
  final AppConfig config;

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
                  label: config.checkout.cantidadLabel,
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
                  label: config.checkout.precioLabel,
                  value: formatEventPrecio(data.event.precio),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  variant: AppCardVariant.filled,
                  child: AppKeyValueRow(
                    label: config.checkout.totalLabel,
                    value: formatEventPrecio(total),
                    emphasize: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        AppBottomActionBar(
          buttonLabel: config.checkout.botonConfirmar,
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
