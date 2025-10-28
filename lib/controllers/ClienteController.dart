import 'package:proyecto/Models/Cliente.dart';

class ClienteController {
  Cliente? _cliente;

  //Guardar cliente
  void guardarCliente(Cliente nuevoCliente) {
    if (_cliente != null) {
      print("⚠️ Ya existe un cliente registrado. Usa actualizarCliente().");
      return;
    }
    _cliente = nuevoCliente;
    print("✅ Cliente guardado correctamente: ${_cliente!.PrimerNombre}");
  }

  //Eliminar cliente (sin parámetro, elimina el que ya existe)
  void eliminarCliente() {
    if (_cliente == null) {
      print("⚠️ No hay cliente registrado para eliminar.");
      return;
    }
    print("🗑️ Cliente eliminado: ${_cliente!.PrimerNombre}");
    _cliente = null;
  }

  //Obtener cliente actual
  Cliente? obtenerCliente() {
    if (_cliente == null) {
      print("⚠️ No hay cliente registrado actualmente.");
      return null;
    }
    return _cliente;
  }

  //Actualizar cliente (recibe el nuevo como parámetro)
  void actualizarCliente(Cliente clienteActualizado) {
    if (_cliente == null) {
      print("⚠️ No hay cliente para actualizar.");
      return;
    }
    _cliente = clienteActualizado;
    print("🔄 Cliente actualizado correctamente: ${_cliente!.PrimerNombre}");
  }
}
