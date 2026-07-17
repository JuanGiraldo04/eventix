import 'package:eventix/features/reservations/presentation/pages/checkout_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

final GoRoute checkoutRoute = GoRoute(
  path: CheckoutPage.routePath,
  builder: (BuildContext context, GoRouterState state) =>
      CheckoutPage(reservationId: state.pathParameters['reservationId']!),
);
