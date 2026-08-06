class EstadoVacioConfig {
  const EstadoVacioConfig({required this.titulo, required this.mensaje});

  final String titulo;
  final String mensaje;

  factory EstadoVacioConfig.fromJson(Map<String, dynamic> json) =>
      EstadoVacioConfig(
        titulo: json['titulo'] as String,
        mensaje: json['mensaje'] as String,
      );
}
