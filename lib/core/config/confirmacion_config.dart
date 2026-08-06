class ConfirmacionConfig {
  const ConfirmacionConfig({
    required this.titulo,
    required this.subtituloTemplate,
    required this.entradasLabel,
    required this.totalLabel,
    required this.botonVerReservas,
    required this.botonVolverInicio,
  });

  final String titulo;

  /// Plantilla con el placeholder literal `{evento}` — ver [subtituloPara].
  final String subtituloTemplate;
  final String entradasLabel;
  final String totalLabel;
  final String botonVerReservas;
  final String botonVolverInicio;

  String subtituloPara(String evento) =>
      subtituloTemplate.replaceAll('{evento}', evento);

  factory ConfirmacionConfig.fromJson(Map<String, dynamic> json) =>
      ConfirmacionConfig(
        titulo: json['titulo'] as String,
        subtituloTemplate: json['subtitulo_template'] as String,
        entradasLabel: json['entradas_label'] as String,
        totalLabel: json['total_label'] as String,
        botonVerReservas: json['boton_ver_reservas'] as String,
        botonVolverInicio: json['boton_volver_inicio'] as String,
      );
}
