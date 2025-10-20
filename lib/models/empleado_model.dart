class Empleado {
  final String id;
  final String nombre;
  bool estado;
  final String cargo;
  final String telefono;
  final String email;
  final DateTime? fechaContratacion;

  Empleado({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.cargo,
    required this.telefono,
    required this.email,
    this.fechaContratacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'estado': estado,
      'cargo': cargo,
      'telefono': telefono,
      'email': email,
      'fechaContratacion': fechaContratacion?.toIso8601String(),
    };
  }

  factory Empleado.fromMap(Map<String, dynamic> map) {
    return Empleado(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      estado: map['estado'] ?? true,
      cargo: map['cargo'] ?? '',
      telefono: map['telefono'] ?? '',
      email: map['email'] ?? '',
      fechaContratacion: map['fechaContratacion'] != null 
          ? DateTime.parse(map['fechaContratacion'])
          : null,
    );
  }
}