import 'package:eventix/core/config/auth_screen_config.dart';

class AuthConfig {
  const AuthConfig({required this.login, required this.registro});

  final AuthScreenConfig login;
  final AuthScreenConfig registro;

  factory AuthConfig.fromJson(Map<String, dynamic> json) => AuthConfig(
    login: AuthScreenConfig.fromJson(json['login'] as Map<String, dynamic>),
    registro: AuthScreenConfig.fromJson(
      json['registro'] as Map<String, dynamic>,
    ),
  );
}
