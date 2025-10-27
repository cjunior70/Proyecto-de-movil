import 'package:proyecto/Models/Empleado.dart';

class EmpleadoController {
  Empleado? empleado; // único empleado en memoria

  // 🔹 1. Guardar empleado
  void guardarEmpleado(Empleado nuevoEmpleado) {
    if (empleado != null) {
      print("⚠️ Ya existe un empleado registrado. Usa actualizarEmpleado().");
      return;
    }

    empleado = nuevoEmpleado;
    print("✅ Empleado guardado correctamente: ${empleado!.PrimerNombre}");
  }

  // 🔹 2. Eliminar empleado
  void eliminarEmpleado() {
    if (empleado == null) {
      print("⚠️ No hay empleado registrado para eliminar.");
      return;
    }

    print("🗑️ Empleado eliminado: ${empleado!.PrimerNombre}");
    empleado = null;
  }

  // 🔹 3. Obtener empleado actual
  Empleado? obtenerEmpleado() {
    if (empleado == null) {
      print("⚠️ No hay empleado registrado actualmente.");
      return null;
    }
    return empleado;
  }

  // 🔹 4. Actualizar empleado existente
  void actualizarEmpleado(Empleado empleadoActualizado) {
    if (empleado == null) {
      print("⚠️ No hay empleado registrado para actualizar.");
      return;
    }

    if (empleado!.Id != empleadoActualizado.Id) {
      print("⚠️ El ID ingresado no coincide con el empleado actual.");
      return;
    }

    empleado = empleadoActualizado;
    empleado!.FechaActual = DateTime.now(); // 👈 se actualiza la fecha automáticamente

    print("🔄 Empleado actualizado correctamente: ${empleado!.PrimerNombre}");
  }
}
