import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:eventix/core/config/app_config.dart';
import 'package:eventix/core/config/app_config_provider.dart';
import 'package:eventix/core/config/app_info_config.dart';
import 'package:eventix/core/config/auth_config.dart';
import 'package:eventix/core/config/auth_screen_config.dart';
import 'package:eventix/core/config/banner_config.dart';
import 'package:eventix/core/config/categoria_config.dart';
import 'package:eventix/core/config/checkout_config.dart';
import 'package:eventix/core/config/confirmacion_config.dart';
import 'package:eventix/core/config/estado_vacio_config.dart';
import 'package:eventix/core/config/eventos_config.dart';
import 'package:eventix/core/config/navbar_config.dart';
import 'package:eventix/core/config/perfil_config.dart';
import 'package:eventix/core/config/reservas_config.dart';
import 'package:eventix/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/src/framework.dart';

/// Espejo de `assets/config/app_config.json` — todas las páginas leen
/// `appConfigProvider.requireValue`, así que cada widget test necesita un
/// `AppConfig` ya resuelto (no un `AsyncLoading` real cargando el asset).
/// Se mantiene igual al JSON default a propósito: varios tests existentes
/// comparan contra textos que hoy vienen de ahí (p. ej. el label del botón
/// de login/registro).
const AppConfig testAppConfig = AppConfig(
  app: AppInfoConfig(nombre: 'Eventix', slogan: 'Tu entrada al deporte'),
  auth: AuthConfig(
    login: AuthScreenConfig(
      titulo: 'Bienvenido de nuevo',
      subtitulo: 'Inicia sesión para continuar',
      boton: 'Iniciar sesión',
    ),
    registro: AuthScreenConfig(
      titulo: 'Crea tu cuenta',
      subtitulo: 'Únete a Eventix hoy',
      boton: 'Crear cuenta',
    ),
  ),
  eventos: EventosConfig(
    tituloSeccion: 'Eventos disponibles',
    saludo: 'Hola,',
    saludoEmoji: '👋',
    categorias: <CategoriaConfig>[
      CategoriaConfig(id: 'futbol', label: 'Fútbol', icono: 'sports_soccer'),
      CategoriaConfig(
        id: 'baloncesto',
        label: 'Baloncesto',
        icono: 'sports_basketball',
      ),
      CategoriaConfig(id: 'tenis', label: 'Tenis', icono: 'sports_tennis'),
      CategoriaConfig(
        id: 'atletismo',
        label: 'Atletismo',
        icono: 'directions_run',
      ),
      CategoriaConfig(id: 'natacion', label: 'Natación', icono: 'pool'),
    ],
    estadoVacio: EstadoVacioConfig(
      titulo: 'Sin eventos',
      mensaje: 'No hay eventos disponibles con los filtros aplicados.',
    ),
  ),
  reservas: ReservasConfig(
    tituloSeccion: 'Mis entradas',
    estadoVacio: EstadoVacioConfig(
      titulo: 'Sin reservas',
      mensaje: 'Aún no tienes entradas. ¡Explora los eventos!',
    ),
  ),
  banners: <BannerConfig>[
    BannerConfig(
      id: 'banner_1',
      activo: true,
      titulo: 'Final de Champions',
      mensaje: 'Entradas disponibles por tiempo limitado.',
      variante: 'info',
    ),
    BannerConfig(
      id: 'banner_2',
      activo: true,
      titulo: 'Nuevo: pago en cuotas',
      mensaje: 'Paga tus entradas en 3 cuotas sin interés.',
      variante: 'success',
    ),
    BannerConfig(
      id: 'banner_3',
      activo: false,
      titulo: 'Mantenimiento programado',
      mensaje: 'El sábado habrá mantenimiento entre 2am y 4am.',
      variante: 'warning',
    ),
  ],
  checkout: CheckoutConfig(
    titulo: 'Confirmar reserva',
    cantidadLabel: 'Cantidad de entradas',
    precioLabel: 'Precio por entrada',
    totalLabel: 'Total',
    botonConfirmar: 'Confirmar compra',
  ),
  confirmacion: ConfirmacionConfig(
    titulo: '¡Reserva confirmada!',
    subtituloTemplate: 'Tu lugar en {evento} está asegurado.',
    entradasLabel: 'Entradas',
    totalLabel: 'Total pagado',
    botonVerReservas: 'Ver mis reservas',
    botonVolverInicio: 'Volver al inicio',
  ),
  navbar: NavbarConfig(
    explorar: 'Explorar',
    explorarIcono: 'explore',
    reservas: 'Reservas',
    reservasIcono: 'confirmation_number',
    perfil: 'Perfil',
    perfilIcono: 'person',
  ),
  perfil: PerfilConfig(icono: 'person'),
);

/// Envuelve [child] en un ProviderScope (con [overrides]) + MaterialApp con
/// el tema y los delegates de localización reales de la app, replicando el
/// árbol de widgets que [MainApp] arma en producción — así las páginas que
/// leen `AppLocalizations.of(context)`/`Theme.of(context)` funcionan igual
/// que en la app real. `appConfigProvider` viene pre-resuelto con
/// [testAppConfig] salvo que [overrides] lo pise explícitamente.
Future<void> pumpPage(
  WidgetTester tester, {
  required Widget child,
  List<Override> overrides = const <Override>[],
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        appConfigProvider.overrideWith((Ref ref) => testAppConfig),
        ...overrides,
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    ),
  );
}
