import 'package:eventix/core/config/app_config.dart';
import 'package:eventix/core/config/app_config_provider.dart';
import 'package:eventix/core/config/config_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppConfig config = ref.watch(appConfigProvider).requireValue;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(iconByName(config.navbar.explorarIcono)),
            label: config.navbar.explorar,
          ),
          NavigationDestination(
            icon: Icon(iconByName(config.navbar.reservasIcono)),
            label: config.navbar.reservas,
          ),
          NavigationDestination(
            icon: Icon(iconByName(config.navbar.perfilIcono)),
            label: config.navbar.perfil,
          ),
        ],
      ),
    );
  }
}
