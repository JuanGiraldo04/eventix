import 'package:eventix/core/config/app_info_config.dart';
import 'package:eventix/core/config/auth_config.dart';
import 'package:eventix/core/config/banner_config.dart';
import 'package:eventix/core/config/checkout_config.dart';
import 'package:eventix/core/config/confirmacion_config.dart';
import 'package:eventix/core/config/eventos_config.dart';
import 'package:eventix/core/config/navbar_config.dart';
import 'package:eventix/core/config/perfil_config.dart';
import 'package:eventix/core/config/reservas_config.dart';

class AppConfig {
  const AppConfig({
    required this.app,
    required this.auth,
    required this.eventos,
    required this.reservas,
    required this.banners,
    required this.checkout,
    required this.confirmacion,
    required this.navbar,
    required this.perfil,
  });

  final AppInfoConfig app;
  final AuthConfig auth;
  final EventosConfig eventos;
  final ReservasConfig reservas;
  final List<BannerConfig> banners;
  final CheckoutConfig checkout;
  final ConfirmacionConfig confirmacion;
  final NavbarConfig navbar;
  final PerfilConfig perfil;

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    app: AppInfoConfig.fromJson(json['app'] as Map<String, dynamic>),
    auth: AuthConfig.fromJson(json['auth'] as Map<String, dynamic>),
    eventos: EventosConfig.fromJson(json['eventos'] as Map<String, dynamic>),
    reservas: ReservasConfig.fromJson(
      json['reservas'] as Map<String, dynamic>,
    ),
    banners: (json['banners'] as List<dynamic>)
        .map((dynamic e) => BannerConfig.fromJson(e as Map<String, dynamic>))
        .toList(),
    checkout: CheckoutConfig.fromJson(
      json['checkout'] as Map<String, dynamic>,
    ),
    confirmacion: ConfirmacionConfig.fromJson(
      json['confirmacion'] as Map<String, dynamic>,
    ),
    navbar: NavbarConfig.fromJson(json['navbar'] as Map<String, dynamic>),
    perfil: PerfilConfig.fromJson(json['perfil'] as Map<String, dynamic>),
  );
}
