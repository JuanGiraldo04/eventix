class CheckoutConfig {
  const CheckoutConfig({
    required this.titulo,
    required this.cantidadLabel,
    required this.precioLabel,
    required this.totalLabel,
    required this.botonConfirmar,
  });

  final String titulo;
  final String cantidadLabel;
  final String precioLabel;
  final String totalLabel;
  final String botonConfirmar;

  factory CheckoutConfig.fromJson(Map<String, dynamic> json) => CheckoutConfig(
    titulo: json['titulo'] as String,
    cantidadLabel: json['cantidad_label'] as String,
    precioLabel: json['precio_label'] as String,
    totalLabel: json['total_label'] as String,
    botonConfirmar: json['boton_confirmar'] as String,
  );
}
