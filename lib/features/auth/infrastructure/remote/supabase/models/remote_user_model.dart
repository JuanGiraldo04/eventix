class RemoteUserModel {
  const RemoteUserModel({
    required this.id,
    required this.email,
    required this.nombre,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String nombre;
  final String? avatarUrl;

  factory RemoteUserModel.fromJson(Map<String, dynamic> json) =>
      RemoteUserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        nombre: json['nombre'] as String,
        avatarUrl: json['avatar_url'] as String?,
      );
}
