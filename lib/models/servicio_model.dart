class Servicio {
  final String id;
  final String nombre;
  final double precio;
  final String duracion;
  final String? descripcion;
  final bool activo;

  Servicio({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.duracion,
    this.descripcion,
    this.activo = true,
  });

  // Convertir a Map para Firebase/API
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'duracion': duracion,
      'descripcion': descripcion,
      'activo': activo,
    };
  }

  // Crear desde Map
  factory Servicio.fromMap(Map<String, dynamic> map) {
    return Servicio(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      precio: map['precio']?.toDouble() ?? 0.0,
      duracion: map['duracion'] ?? '',
      descripcion: map['descripcion'],
      activo: map['activo'] ?? true,
    );
  }
}