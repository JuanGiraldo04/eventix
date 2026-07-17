import 'package:eventix/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

final GoRoute profileRoute = GoRoute(
  path: ProfilePage.routePath,
  builder: (BuildContext context, GoRouterState state) => const ProfilePage(),
);
