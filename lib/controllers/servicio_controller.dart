import '../Models/servicio_model.dart';

class ServicioController {
  List<Servicio> _servicios = [];

  List<Servicio> get servicios => _servicios;

  // Agregar servicio
  void agregarServicio(Servicio servicio) {
    _servicios.add(servicio);
  }

  // Editar servicio
  void editarServicio(String id, Servicio servicioActualizado) {
    final index = _servicios.indexWhere((servicio) => servicio.id == id);
    if (index != -1) {
      _servicios[index] = servicioActualizado;
    }
  }

  // Eliminar servicio
  void eliminarServicio(String id) {
    _servicios.removeWhere((servicio) => servicio.id == id);
  }

  // Obtener servicio por ID
  Servicio? obtenerServicioPorId(String id) {
    try {
      return _servicios.firstWhere((servicio) => servicio.id == id);
    } catch (e) {
      return null;
    }
  }

  // Cargar servicios de ejemplo (temporal)
  void cargarServiciosEjemplo() {
    _servicios = [
      Servicio(
        id: '1',
        nombre: 'Corte de pelo',
        precio: 2000,
        duracion: '2.00 minutos',
      ),
      Servicio(
        id: '2',
        nombre: 'Lavado de pelo',
        precio: 6000,
        duracion: '4.00 minutos',
      ),
    ];
  }

  // Validar datos del servicio
  String? validarServicio(String nombre, String precio, String duracion) {
    if (nombre.isEmpty) return 'El nombre es obligatorio';
    if (precio.isEmpty) return 'El precio es obligatorio';
    if (double.tryParse(precio) == null) return 'Precio debe ser un número válido';
    if (duracion.isEmpty) return 'La duración es obligatoria';
    
    return null;
  }
}