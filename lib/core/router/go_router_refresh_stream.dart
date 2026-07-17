import 'dart:async';

import 'package:flutter/foundation.dart';

/// Convierte un [Stream] en un [Listenable] para usarlo como
/// `refreshListenable` de GoRouter — así el router reevalúa `redirect`
/// cada vez que cambia el estado de autenticación de Supabase.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
    super.dispose();
  }
}
