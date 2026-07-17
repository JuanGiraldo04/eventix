import 'package:eventix/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

final GoRoute registerRoute = GoRoute(
  path: RegisterPage.routePath,
  builder: (BuildContext context, GoRouterState state) => const RegisterPage(),
);
