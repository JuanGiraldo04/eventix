import 'package:eventix/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

final GoRoute loginRoute = GoRoute(
  path: LoginPage.routePath,
  builder: (BuildContext context, GoRouterState state) => const LoginPage(),
);
