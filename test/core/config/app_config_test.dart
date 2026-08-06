import 'dart:convert';
import 'dart:io';

import 'package:eventix/core/config/app_config.dart';
import 'package:eventix/core/config/banner_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig.fromJson', () {
    test(
      'given app_config.json when parsed then every section deserializes',
      () {
        final String raw = File(
          'assets/config/app_config.json',
        ).readAsStringSync();
        final AppConfig config = AppConfig.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );

        expect(config.app.nombre, 'Eventix');
        expect(config.auth.login.boton, 'Iniciar sesión');
        expect(config.auth.registro.boton, 'Crear cuenta');
        expect(config.eventos.categorias, hasLength(5));
        expect(config.eventos.categorias.first.id, 'futbol');
        expect(config.eventos.estadoVacio.titulo, 'Sin eventos');
        expect(config.reservas.tituloSeccion, 'Mis entradas');
        expect(config.banners, hasLength(3));
        expect(
          config.banners.where((BannerConfig b) => b.activo),
          hasLength(2),
        );
        expect(config.navbar.explorarIcono, 'explore');
        expect(config.perfil.icono, 'person');
      },
    );

    test(
      'given app_config_alt.json when parsed then every section deserializes',
      () {
        final String raw = File(
          'assets/config/app_config_alt.json',
        ).readAsStringSync();
        final AppConfig config = AppConfig.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );

        expect(config.app.nombre, 'SportPass');
        expect(config.eventos.categorias.first.label, 'Soccer');
        expect(config.reservas.tituloSeccion, 'Mis tickets');
        expect(config.banners, hasLength(3));
        expect(
          config.banners.where((BannerConfig b) => b.activo),
          hasLength(3),
        );
        expect(config.perfil.icono, 'military_tech');
      },
    );
  });
}
