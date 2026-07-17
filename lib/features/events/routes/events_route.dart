import 'package:eventix/features/events/presentation/pages/events_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

final GoRoute eventsRoute = GoRoute(
  path: EventsPage.routePath,
  builder: (BuildContext context, GoRouterState state) => const EventsPage(),
);
