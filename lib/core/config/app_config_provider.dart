import 'dart:convert';

import 'package:eventix/core/config/app_config.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config_provider.g.dart';

const String defaultConfigPath = 'assets/config/app_config.json';
const String altConfigPath = 'assets/config/app_config_alt.json';

@riverpod
class ActiveConfigPath extends _$ActiveConfigPath {
  @override
  String build() => defaultConfigPath;

  void toggle() {
    state = state == defaultConfigPath ? altConfigPath : defaultConfigPath;
  }
}

@riverpod
Future<AppConfig> appConfig(Ref ref) async {
  final String path = ref.watch(activeConfigPathProvider);
  final String raw = await rootBundle.loadString(path);
  return AppConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
