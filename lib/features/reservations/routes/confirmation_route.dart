import 'package:eventix/features/reservations/presentation/pages/confirmation_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

final GoRoute confirmationRoute = GoRoute(
  path: ConfirmationPage.routePath,
  builder: (BuildContext context, GoRouterState state) =>
      ConfirmationPage(reservationId: state.pathParameters['reservationId']!),
);
