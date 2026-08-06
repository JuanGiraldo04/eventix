import 'package:eventix/core/config/estado_vacio_config.dart';

class ReservasConfig {
  const ReservasConfig({
    required this.tituloSeccion,
    required this.estadoVacio,
  });

  final String tituloSeccion;
  final EstadoVacioConfig estadoVacio;

  factory ReservasConfig.fromJson(Map<String, dynamic> json) => ReservasConfig(
    tituloSeccion: json['titulo_seccion'] as String,
    estadoVacio: EstadoVacioConfig.fromJson(
      json['estado_vacio'] as Map<String, dynamic>,
    ),
  );
}
