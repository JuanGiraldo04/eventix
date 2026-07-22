import 'package:eventix/features/reservations/presentation/providers/checkout_quantity_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
    container.listen(
      checkoutQuantityProvider('res-1'),
      (int? _, int _) {},
    );
  });

  group('CheckoutQuantityNotifier', () {
    test(
      'given the notifier was just created '
      'when build runs '
      'then the initial value is 1',
      () {
        expect(container.read(checkoutQuantityProvider('res-1')), 1);
      },
    );

    test(
      'given the current quantity is below the max '
      'when increment is called '
      'then the quantity increases by one',
      () {
        container.read(checkoutQuantityProvider('res-1').notifier).increment(5);

        expect(container.read(checkoutQuantityProvider('res-1')), 2);
      },
    );

    test(
      'given the current quantity equals the max '
      'when increment is called '
      'then the quantity does not change',
      () {
        final CheckoutQuantityNotifier notifier = container.read(
          checkoutQuantityProvider('res-1').notifier,
        );
        notifier
          ..increment(2)
          ..increment(2);

        expect(container.read(checkoutQuantityProvider('res-1')), 2);
      },
    );

    test(
      'given the current quantity is above 1 '
      'when decrement is called '
      'then the quantity decreases by one',
      () {
        final CheckoutQuantityNotifier notifier = container.read(
          checkoutQuantityProvider('res-1').notifier,
        );
        notifier.increment(5);

        notifier.decrement();

        expect(container.read(checkoutQuantityProvider('res-1')), 1);
      },
    );

    test(
      'given the current quantity is 1 '
      'when decrement is called '
      'then the quantity does not go below 1',
      () {
        container.read(checkoutQuantityProvider('res-1').notifier).decrement();

        expect(container.read(checkoutQuantityProvider('res-1')), 1);
      },
    );
  });
}
