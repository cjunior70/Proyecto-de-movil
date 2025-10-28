import '../models/empresa_model.dart';

class EmpresaController {
  Empresa? _empresaActual;

  Empresa? get empresaActual => _empresaActual;

  // Cargar datos de empresa (temporal)
  void cargarEmpresaEjemplo() {
    _empresaActual = Empresa(
      id: '1',
      nombre: 'Empresa Josemaria',
      direccion: 'Tranversal 27 b #09-12',
      telefono: '+57 300 123 4567',
      email: 'contacto@josemaria.com',
      descripcion: 'Salón de belleza especializado en cortes modernos y tratamientos capilares.',
      redesSociales: ['@josemaria_beauty', 'facebook.com/josemaria'],
      totalReviews: 98,
      ratingPromedio: 4.5,
    );
  }

  // Actualizar información de la empresa
  void actualizarEmpresa(Empresa empresa) {
    _empresaActual = empresa;
  }

  // Validar datos de empresa
  String? validarEmpresa(String nombre, String direccion, String telefono, String email) {
    if (nombre.isEmpty) return 'El nombre es obligatorio';
    if (direccion.isEmpty) return 'La dirección es obligatoria';
    if (telefono.isEmpty) return 'El teléfono es obligatorio';
    if (email.isEmpty) return 'El email es obligatorio';
    if (!email.contains('@')) return 'Email debe ser válido';
    
    return null;
  }
}
