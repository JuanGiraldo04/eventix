class CategoriaConfig {
  const CategoriaConfig({
    required this.id,
    required this.label,
    required this.icono,
  });

  final String id;
  final String label;
  final String icono;

  factory CategoriaConfig.fromJson(Map<String, dynamic> json) =>
      CategoriaConfig(
        id: json['id'] as String,
        label: json['label'] as String,
        icono: json['icono'] as String,
      );
}
