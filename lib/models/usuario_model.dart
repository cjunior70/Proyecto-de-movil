class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String rol; // 'admin', 'usuario', 'empleaddo'
  final String? telefono;
  final String? fotoUrl;
  final DateTime fechaRegistro;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    this.telefono,
    this.fotoUrl,
    required this.fechaRegistro,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'rol': rol,
      'telefono': telefono,
      'fotoUrl': fotoUrl,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      rol: map['rol'] ?? 'usuario',
      telefono: map['telefono'],
      fotoUrl: map['fotoUrl'],
      fechaRegistro: DateTime.parse(map['fechaRegistro'] ?? DateTime.now().toIso8601String()),
    );
  }
}