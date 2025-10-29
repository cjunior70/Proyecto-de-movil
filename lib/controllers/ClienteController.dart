import 'package:proyecto/Models/Cliente.dart';

class ClienteController {
  // Singleton
  static final ClienteController _instance = ClienteController._internal();
  factory ClienteController() => _instance;
  ClienteController._internal();

  Cliente? _cliente;

  // Guardar cliente
  void guardarCliente(Cliente nuevoCliente) {
    if (_cliente != null) {
      print("⚠️ Ya existe un cliente registrado. Usa actualizarCliente().");
      return;
    }
    _cliente = nuevoCliente;
    print("✅ Cliente guardado correctamente: ${_cliente!.PrimerNombre}");
  }

  // Eliminar cliente
  void eliminarCliente() {
    if (_cliente == null) {
      print("⚠️ No hay cliente registrado para eliminar.");
      return;
    }
    print("🗑️ Cliente eliminado: ${_cliente!.PrimerNombre}");
    _cliente = null;
  }

  // Obtener cliente
  Cliente? obtenerCliente() {
    if (_cliente == null) {
      print("⚠️ No hay cliente registrado actualmente.");
      return null;
    }
    print("✅ Datos mostrados: ${_cliente!.Cedula}");
    return _cliente;
  }

  // Actualizar cliente
  void actualizarCliente(Cliente clienteActualizado) {
    if (_cliente == null) {
      print("⚠️ No hay cliente para actualizar.");
      return;
    }
    _cliente = clienteActualizado;
    print("🔄 Cliente actualizado correctamente: ${_cliente!.PrimerNombre}");
  }
}
