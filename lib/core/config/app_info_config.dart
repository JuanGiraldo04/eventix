class AppInfoConfig {
  const AppInfoConfig({required this.nombre, required this.slogan});

  final String nombre;
  final String slogan;

  factory AppInfoConfig.fromJson(Map<String, dynamic> json) => AppInfoConfig(
    nombre: json['nombre'] as String,
    slogan: json['slogan'] as String,
  );
}
