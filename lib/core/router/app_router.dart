import 'package:eventix/core/router/app_shell.dart';
import 'package:eventix/core/router/go_router_refresh_stream.dart';
import 'package:eventix/core/router/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: SplashPage.routePath,
  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange,
  ),
  redirect: (BuildContext context, GoRouterState state) {
    final String location = state.matchedLocation;
    if (location == SplashPage.routePath) return null;

    final bool isLoggedIn =
        Supabase.instance.client.auth.currentSession != null;
    final bool isAuthRoute =
        location == LoginPage.routePath || location == RegisterPage.routePath;

    if (!isLoggedIn && !isAuthRoute) return LoginPage.routePath;
    if (isLoggedIn && isAuthRoute) return EventsPage.routePath;
    return null;
  },
  routes: <RouteBase>[
    splashRoute,
    loginRoute,
    registerRoute,
    checkoutRoute,
    confirmationRoute,
    StatefulShellRoute.indexedStack(
      builder:
          (
            BuildContext context,
            GoRouterState state,
            StatefulNavigationShell navigationShell,
          ) => AppShell(navigationShell: navigationShell),
      branches: <StatefulShellBranch>[
        StatefulShellBranch(routes: <RouteBase>[eventsRoute, eventDetailRoute]),
        StatefulShellBranch(
          routes: <RouteBase>[reservationsRoute, reservationDetailRoute],
        ),
        StatefulShellBranch(routes: <RouteBase>[profileRoute]),
      ],
    ),
  ],
);
