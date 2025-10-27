import 'package:proyecto/Models/Contabilidad.dart';

class ContabilidadController {
  Contabilidad? contabilidad; // solo una contabilidad activa

  // 🔹 1. Guardar contabilidad
  void guardarContabilidad(Contabilidad nuevaContabilidad) {
    if (contabilidad != null) {
      print("⚠️ Ya existe una contabilidad registrada. Usa actualizarContabilidad().");
      return;
    }

    contabilidad = nuevaContabilidad;
    print("✅ Contabilidad guardada correctamente con ID: ${contabilidad!.Id}");
  }

  // 🔹 2. Eliminar contabilidad
  void eliminarContabilidad() {
    if (contabilidad == null) {
      print("⚠️ No hay contabilidad registrada para eliminar.");
      return;
    }

    print("🗑️ Contabilidad eliminada con ID: ${contabilidad!.Id}");
    contabilidad = null;
  }

  // 🔹 3. Obtener contabilidad actual
  Contabilidad? obtenerContabilidad() {
    if (contabilidad == null) {
      print("⚠️ No hay contabilidad registrada actualmente.");
      return null;
    }
    return contabilidad;
  }

  // 🔹 4. Actualizar contabilidad (por ID)
  void actualizarContabilidad(Contabilidad contabilidadActualizada) {
    if (contabilidad == null) {
      print("⚠️ No hay contabilidad registrada para actualizar.");
      return;
    }

    if (contabilidad!.Id != contabilidadActualizada.Id) {
      print("⚠️ El ID ingresado no coincide con la contabilidad actual.");
      return;
    }

    contabilidad = contabilidadActualizada;
    contabilidad!.Fecha = DateTime.now(); // 👈 actualiza fecha automáticamente

    print("🔄 Contabilidad actualizada correctamente con ID: ${contabilidad!.Id}");
  }
}
