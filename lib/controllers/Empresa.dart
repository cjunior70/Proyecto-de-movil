import 'package:proyecto/Models/Empresa.dart';


class EmpresaController {
  Empresa? empresa; // una sola empresa cargada en memoria

  // 🔹 1. Guardar empresa
  void guardarEmpresa(Empresa nuevaEmpresa) {
    if (empresa != null) {
      print("⚠️ Ya existe una empresa registrada. Usa actualizarEmpresa().");
      return;
    }

    empresa = nuevaEmpresa;
    print("✅ Empresa guardada correctamente: ${empresa!.Nombre}");
  }

  // 🔹 2. Eliminar empresa
  void eliminarEmpresa() {
    if (empresa == null) {
      print("⚠️ No hay empresa registrada para eliminar.");
      return;
    }

    print("🗑️ Empresa eliminada: ${empresa!.Nombre}");
    empresa = null;
  }

  // 🔹 3. Obtener empresa actual
  Empresa? obtenerEmpresa() {
    if (empresa == null) {
      print("⚠️ No hay empresa registrada actualmente.");
      return null;
    }
    return empresa;
  }

  // 🔹 4. Actualizar empresa existente
  void actualizarEmpresa(Empresa empresaActualizada) {
    if (empresa == null) {
      print("⚠️ No hay empresa registrada para actualizar.");
      return;
    }

    if (empresa!.Id != empresaActualizada.Id) {
      print("⚠️ El ID no coincide con la empresa actual.");
      return;
    }

    empresa = empresaActualizada;
    print("🔄 Empresa actualizada correctamente: ${empresa!.Nombre}");
  }

  // 🔹 5. Agregar servicio a la empresa
  void agregarServicio(servicio) {
    empresa?.ListaDeServicios ??= [];
    empresa!.ListaDeServicios!.add(servicio);
    print("🧩 Servicio agregado a la empresa: ${empresa!.Nombre}");
  }

  // 🔹 6. Agregar empleado a la empresa
  void agregarEmpleado(empleado) {
    empresa?.ListaDeEmpleados ??= [];
    empresa!.ListaDeEmpleados!.add(empleado);
    print("👨‍💼 Empleado agregado a la empresa: ${empresa!.Nombre}");
  }

  // 🔹 7. Mostrar resumen de la empresa
  void mostrarResumen() {
    if (empresa == null) {
      print("⚠️ No hay empresa registrada.");
      return;
    }

    print("""
🏢 Empresa: ${empresa!.Nombre}
⭐ Estrellas: ${empresa!.Estrellas}
📧 Correo: ${empresa!.Correo}
👥 Empleados: ${empresa!.ListaDeEmpleados?.length ?? 0}
🧩 Servicios: ${empresa!.ListaDeServicios?.length ?? 0}
📅 Reservaciones: ${empresa!.ListaDeReservaciones?.length ?? 0}
""");
  }
}
