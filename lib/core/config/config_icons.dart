import 'package:flutter/material.dart';

/// Registro único de nombres de ícono usados en `app_config*.json`
/// (categorías, navbar, perfil). Un nombre no reconocido cae a un ícono
/// genérico en vez de romper la app.
IconData iconByName(String name) => switch (name) {
  'sports_soccer' => Icons.sports_soccer,
  'sports_basketball' => Icons.sports_basketball,
  'sports_tennis' => Icons.sports_tennis,
  'directions_run' => Icons.directions_run,
  'directions_bike' => Icons.directions_bike,
  'pool' => Icons.pool,
  'waves' => Icons.waves,
  'emoji_events' => Icons.emoji_events,
  'scoreboard' => Icons.scoreboard,
  'fitness_center' => Icons.fitness_center,
  'explore' => Icons.explore,
  'search' => Icons.search,
  'confirmation_number' => Icons.confirmation_number,
  'local_activity' => Icons.local_activity,
  'person' => Icons.person,
  'account_circle' => Icons.account_circle,
  'military_tech' => Icons.military_tech,
  _ => Icons.sports,
};
