import '../models/empresa_model.dart';

class EmpresaController {
  List<Empresa> _empresas = [];
  Empresa? _empresaActual;

  // Getters
  List<Empresa> get empresas => _empresas;
  Empresa? get empresaActual => _empresaActual;

  // 🔹 1. Cargar datos de ejemplo (para desarrollo)
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

  // 🔹 2. Cargar múltiples empresas para ListaEmpresas
  void cargarEmpresasEjemplo() {
    _empresas = [
      Empresa(
        id: '1',
        nombre: 'Empresa Josemaria',
        direccion: 'Tranversal 27 b #09-12',
        telefono: '+57 300 123 4567',
        email: 'contacto@josemaria.com',
        descripcion: 'Salón de belleza especializado en cortes modernos',
        ratingPromedio: 4.5,
        totalReviews: 98,
      ),
      Empresa(
        id: '2',
        nombre: 'Belleza Total Spa',
        direccion: 'Calle 45 #12-34, Centro',
        telefono: '+57 310 555 7890',
        email: 'info@bellezatotal.com',
        descripcion: 'Spa y centro de estética integral con los mejores tratamientos',
        ratingPromedio: 4.2,
        totalReviews: 45,
      ),
      Empresa(
        id: '3', 
        nombre: 'Style & Color',
        direccion: 'Avenida Principal #67-89',
        telefono: '+57 320 888 1234',
        email: 'reservas@stylecolor.com',
        descripcion: 'Especialistas en coloración y cortes de tendencia',
        ratingPromedio: 4.7,
        totalReviews: 120,
      ),
    ];
  }

  // 🔹 3. Validar datos de empresa (que usas en RegistrarEmpresaPage)
  String? validarEmpresa(String nombre, String direccion, String telefono, String email) {
    if (nombre.isEmpty) return 'El nombre es obligatorio';
    if (direccion.isEmpty) return 'La dirección es obligatoria';
    if (telefono.isEmpty) return 'El teléfono es obligatorio';
    if (email.isEmpty) return 'El email es obligatorio';
    if (!email.contains('@')) return 'Email debe ser válido';
    
    return null;
  }

  // 🔹 4. Guardar nueva empresa
  void guardarEmpresa(Empresa nuevaEmpresa) {
    _empresas.add(nuevaEmpresa);
    _empresaActual = nuevaEmpresa;
  }

  // 🔹 5. Actualizar empresa existente
  void actualizarEmpresa(Empresa empresaActualizada) {
    final index = _empresas.indexWhere((e) => e.id == empresaActualizada.id);
    if (index != -1) {
      _empresas[index] = empresaActualizada;
    }
    _empresaActual = empresaActualizada;
  }

  // 🔹 6. Eliminar empresa
  void eliminarEmpresa(String id) {
    _empresas.removeWhere((empresa) => empresa.id == id);
    if (_empresaActual?.id == id) {
      _empresaActual = null;
    }
  }

  // 🔹 7. Obtener empresa por ID
  Empresa? obtenerEmpresaPorId(String id) {
    try {
      return _empresas.firstWhere((empresa) => empresa.id == id);
    } catch (e) {
      return null;
    }
  }

  // 🔹 8. Buscar empresas por nombre
  List<Empresa> buscarEmpresas(String query) {
    if (query.isEmpty) return _empresas;
    
    return _empresas.where((empresa) => 
      empresa.nombre.toLowerCase().contains(query.toLowerCase()) ||
      empresa.direccion.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}