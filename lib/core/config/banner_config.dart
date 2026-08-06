class BannerConfig {
  const BannerConfig({
    required this.id,
    required this.activo,
    required this.titulo,
    required this.mensaje,
    required this.variante,
  });

  final String id;
  final bool activo;
  final String titulo;
  final String mensaje;
  final String variante;

  factory BannerConfig.fromJson(Map<String, dynamic> json) => BannerConfig(
    id: json['id'] as String,
    activo: json['activo'] as bool,
    titulo: json['titulo'] as String,
    mensaje: json['mensaje'] as String,
    variante: json['variante'] as String,
  );
}
