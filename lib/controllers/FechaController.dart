import 'package:proyecto/Models/Fecha.dart';

class FechaController {
  Fecha? fecha; // una sola fecha cargada en memoria

  // 🔹 1. Guardar fecha
  void guardarFecha(Fecha nuevaFecha) {
    if (fecha != null) {
      print("⚠️ Ya existe una fecha registrada. Usa actualizarFecha().");
      return;
    }

    fecha = nuevaFecha;
    print("✅ Fecha guardada correctamente: ${fecha!.FechaActual}");
  }

  // 🔹 2. Eliminar fecha
  void eliminarFecha() {
    if (fecha == null) {
      print("⚠️ No hay fecha registrada para eliminar.");
      return;
    }

    print("🗑️ Fecha eliminada: ${fecha!.FechaActual}");
    fecha = null;
  }

  // 🔹 3. Obtener fecha actual
  Fecha? obtenerFecha() {
    if (fecha == null) {
      print("⚠️ No hay fecha registrada actualmente.");
      return null;
    }
    return fecha;
  }

  // 🔹 4. Actualizar fecha existente
  void actualizarFecha(Fecha fechaActualizada) {
    if (fecha == null) {
      print("⚠️ No hay fecha registrada para actualizar.");
      return;
    }

    if (fecha!.Id != fechaActualizada.Id) {
      print("⚠️ El ID no coincide con la fecha actual.");
      return;
    }

    fecha = fechaActualizada;
    print("🔄 Fecha actualizada correctamente: ${fecha!.FechaActual}");
  }
}
