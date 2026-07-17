import 'package:eventix/features/events/presentation/pages/event_detail_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

final GoRoute eventDetailRoute = GoRoute(
  path: EventDetailPage.routePath,
  builder: (BuildContext context, GoRouterState state) =>
      EventDetailPage(eventId: state.pathParameters['id']!),
);
