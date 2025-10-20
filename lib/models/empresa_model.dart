class Empresa {
  final String id;
  final String nombre;
  final String direccion;
  final String telefono;
  final String email;
  final String descripcion;
  final List<String> redesSociales;
  final int totalReviews;
  final double ratingPromedio;

  Empresa({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.email,
    required this.descripcion,
    this.redesSociales = const [],
    this.totalReviews = 0,
    this.ratingPromedio = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'email': email,
      'descripcion': descripcion,
      'redesSociales': redesSociales,
      'totalReviews': totalReviews,
      'ratingPromedio': ratingPromedio,
    };
  }

  factory Empresa.fromMap(Map<String, dynamic> map) {
    return Empresa(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      direccion: map['direccion'] ?? '',
      telefono: map['telefono'] ?? '',
      email: map['email'] ?? '',
      descripcion: map['descripcion'] ?? '',
      redesSociales: List<String>.from(map['redesSociales'] ?? []),
      totalReviews: map['totalReviews'] ?? 0,
      ratingPromedio: map['ratingPromedio']?.toDouble() ?? 0.0,
    );
  }
}