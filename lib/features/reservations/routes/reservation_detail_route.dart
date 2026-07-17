import 'package:eventix/features/reservations/presentation/pages/reservation_detail_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

final GoRoute reservationDetailRoute = GoRoute(
  path: ReservationDetailPage.routePath,
  builder: (BuildContext context, GoRouterState state) =>
      ReservationDetailPage(reservationId: state.pathParameters['id']!),
);
