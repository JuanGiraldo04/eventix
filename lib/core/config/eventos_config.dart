import 'package:eventix/core/config/categoria_config.dart';
import 'package:eventix/core/config/estado_vacio_config.dart';

class EventosConfig {
  const EventosConfig({
    required this.tituloSeccion,
    required this.saludo,
    required this.saludoEmoji,
    required this.categorias,
    required this.estadoVacio,
  });

  final String tituloSeccion;
  final String saludo;
  final String saludoEmoji;
  final List<CategoriaConfig> categorias;
  final EstadoVacioConfig estadoVacio;

  factory EventosConfig.fromJson(Map<String, dynamic> json) => EventosConfig(
    tituloSeccion: json['titulo_seccion'] as String,
    saludo: json['saludo'] as String,
    saludoEmoji: json['saludo_emoji'] as String,
    categorias: (json['categorias'] as List<dynamic>)
        .map(
          (dynamic e) => CategoriaConfig.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    estadoVacio: EstadoVacioConfig.fromJson(
      json['estado_vacio'] as Map<String, dynamic>,
    ),
  );
}
