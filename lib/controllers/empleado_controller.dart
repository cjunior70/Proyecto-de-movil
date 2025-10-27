import '../Models/empleado_model.dart';

class EmpleadoController {
  List<Empleado> _empleados = [];

  List<Empleado> get empleados => _empleados;

  // Cargar empleados de ejemplo
  void cargarEmpleadosEjemplo() {
    _empleados = [
      Empleado(
        id: '1',
        nombre: 'Sofía Vergara',
        estado: true,
        cargo: 'Estilista Senior',
        telefono: '+57 300 123 4567',
        email: 'sofia.vergara@empresa.com',
        fechaContratacion: DateTime(2023, 1, 15),
      ),
      Empleado(
        id: '2',
        nombre: 'Sebastian Gomez',
        estado: true,
        cargo: 'Estilista',
        telefono: '+57 300 987 6543',
        email: 'sebastian.gomez@empresa.com',
        fechaContratacion: DateTime(2023, 3, 20),
      ),
      Empleado(
        id: '3',
        nombre: 'Maria Rodriguez',
        estado: false,
        cargo: 'Recepcionista',
        telefono: '+57 300 555 1234',
        email: 'maria.rodriguez@empresa.com',
        fechaContratacion: DateTime(2023, 6, 10),
      ),
    ];
  }

  // Agregar empleado
  void agregarEmpleado(Empleado empleado) {
    _empleados.add(empleado);
  }

  // Editar empleado
  void editarEmpleado(String id, Empleado empleadoActualizado) {
    final index = _empleados.indexWhere((empleado) => empleado.id == id);
    if (index != -1) {
      _empleados[index] = empleadoActualizado;
    }
  }

  // Cambiar estado del empleado
  void cambiarEstadoEmpleado(String id) {
    final index = _empleados.indexWhere((empleado) => empleado.id == id);
    if (index != -1) {
      _empleados[index].estado = !_empleados[index].estado;
    }
  }

  // Eliminar empleado
  void eliminarEmpleado(String id) {
    _empleados.removeWhere((empleado) => empleado.id == id);
  }

  // Obtener empleado por ID
  Empleado? obtenerEmpleadoPorId(String id) {
    try {
      return _empleados.firstWhere((empleado) => empleado.id == id);
    } catch (e) {
      return null;
    }
  }
}
