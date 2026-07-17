import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'checkout_quantity_provider.g.dart';

@riverpod
class CheckoutQuantityNotifier extends _$CheckoutQuantityNotifier {
  @override
  int build(String reservationId) => 1;

  void increment(int maxQuantity) {
    if (state < maxQuantity) state++;
  }

  void decrement() {
    if (state > 1) state--;
  }
}
