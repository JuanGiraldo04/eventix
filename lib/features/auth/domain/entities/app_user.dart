class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.nombre,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String nombre;
  final String? avatarUrl;
}
