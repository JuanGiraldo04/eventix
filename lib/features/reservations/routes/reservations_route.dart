import 'package:eventix/features/reservations/presentation/pages/reservations_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

final GoRoute reservationsRoute = GoRoute(
  path: ReservationsPage.routePath,
  builder: (BuildContext context, GoRouterState state) =>
      const ReservationsPage(),
);
