import 'package:proyecto/Models/Servicio.dart';

class ServicioController {
  Servicios? _servicio; // Solo un servicio cargado en memoria

  // ✅ Guardar servicio (recibe el objeto completo)
  void guardarServicio(Servicios servicio) {
    _servicio = servicio;
    print("✅ Servicio guardado correctamente: ${_servicio!.Nombre}");
  }

  // ✅ Obtener servicio actual
  Servicios? obtenerServicio() {
    if (_servicio == null) {
      print("⚠️ No hay servicio registrado actualmente.");
      return null;
    }
    return _servicio;
  }

  // ✅ Actualizar servicio
  void actualizarServicio(Servicios servicioActualizado) {
    if (_servicio == null) {
      print("⚠️ No hay servicio registrado para actualizar.");
      return;
    }

    if (_servicio!.Id != servicioActualizado.Id) {
      print("⚠️ El ID no coincide con el servicio actual.");
      return;
    }

    _servicio = servicioActualizado;
    print("🔄 Servicio actualizado correctamente: ${_servicio!.Nombre}");
  }

  // ✅ Eliminar servicio
  void eliminarServicio() {
    if (_servicio == null) {
      print("⚠️ No hay servicio registrado para eliminar.");
      return;
    }

    print("🗑️ Servicio eliminado: ${_servicio!.Nombre}");
    _servicio = null;
  }

  // ✅ Mostrar detalles del servicio
  void mostrarServicio() {
    if (_servicio == null) {
      print("⚠️ No hay servicio registrado.");
      return;
    }

    print("""
💈 SERVICIO REGISTRADO
🆔 ID: ${_servicio!.Id}
📛 Nombre: ${_servicio!.Nombre}
💰 Precio: \$${_servicio!.Precio}
⏱️ Tiempo promedio: ${_servicio!.TiempoPromedio.inMinutes} minutos
""");
  }
}
