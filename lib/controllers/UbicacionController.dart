import 'package:proyecto/Models/Ubicacion.dart';

class UbicacionController {
  Ubicacion? _ubicacion; // Solo una ubicación cargada en memoria

  // ✅ Guardar ubicación (recibe el objeto completo)
  void guardarUbicacion(Ubicacion nuevaUbicacion) {
    _ubicacion = nuevaUbicacion;
    print("✅ Ubicación guardada correctamente: ID ${_ubicacion!.Id}");
  }

  // ✅ Obtener ubicación actual
  Ubicacion? obtenerUbicacion() {
    if (_ubicacion == null) {
      print("⚠️ No hay ubicación registrada actualmente.");
      return null;
    }
    return _ubicacion;
  }

  // ✅ Actualizar ubicación existente
  void actualizarUbicacion(Ubicacion ubicacionActualizada) {
    if (_ubicacion == null) {
      print("⚠️ No hay ubicación registrada para actualizar.");
      return;
    }

    if (_ubicacion!.Id != ubicacionActualizada.Id) {
      print("⚠️ El ID no coincide con la ubicación actual.");
      return;
    }

    _ubicacion = ubicacionActualizada;
    print("🔄 Ubicación actualizada correctamente: ID ${_ubicacion!.Id}");
  }

  // ✅ Eliminar ubicación
  void eliminarUbicacion() {
    if (_ubicacion == null) {
      print("⚠️ No hay ubicación registrada para eliminar.");
      return;
    }

    print("🗑️ Ubicación eliminada: ID ${_ubicacion!.Id}");
    _ubicacion = null;
  }

  // ✅ Mostrar detalles de la ubicación
  void mostrarUbicacion() {
    if (_ubicacion == null) {
      print("⚠️ No hay ubicación registrada.");
      return;
    }

    print("""
📍 UBICACIÓN REGISTRADA
🆔 ID: ${_ubicacion!.Id}
🌎 Latitud: ${_ubicacion!.Latitud ?? 'No definida'}
🌍 Longitud: ${_ubicacion!.Longitud ?? 'No definida'}
""");
  }
}
