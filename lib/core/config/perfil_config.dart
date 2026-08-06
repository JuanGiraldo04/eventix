class PerfilConfig {
  const PerfilConfig({required this.icono});

  final String icono;

  factory PerfilConfig.fromJson(Map<String, dynamic> json) =>
      PerfilConfig(icono: json['icono'] as String);
}
