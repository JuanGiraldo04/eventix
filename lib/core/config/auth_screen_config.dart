class AuthScreenConfig {
  const AuthScreenConfig({
    required this.titulo,
    required this.subtitulo,
    required this.boton,
  });

  final String titulo;
  final String subtitulo;
  final String boton;

  factory AuthScreenConfig.fromJson(Map<String, dynamic> json) =>
      AuthScreenConfig(
        titulo: json['titulo'] as String,
        subtitulo: json['subtitulo'] as String,
        boton: json['boton'] as String,
      );
}
