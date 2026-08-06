class NavbarConfig {
  const NavbarConfig({
    required this.explorar,
    required this.explorarIcono,
    required this.reservas,
    required this.reservasIcono,
    required this.perfil,
    required this.perfilIcono,
  });

  final String explorar;
  final String explorarIcono;
  final String reservas;
  final String reservasIcono;
  final String perfil;
  final String perfilIcono;

  factory NavbarConfig.fromJson(Map<String, dynamic> json) => NavbarConfig(
    explorar: json['explorar'] as String,
    explorarIcono: json['explorar_icono'] as String,
    reservas: json['reservas'] as String,
    reservasIcono: json['reservas_icono'] as String,
    perfil: json['perfil'] as String,
    perfilIcono: json['perfil_icono'] as String,
  );
}
