import 'package:proyecto/Models/Empresa.dart';

class EmpresaController {
  // ✅ Lista de todas las empresas en memoria
  List<Empresa> listaEmpresas = [];

  // 🔹 1. Guardar empresa
  void guardarEmpresa(Empresa nuevaEmpresa) {
    bool existe = listaEmpresas.any((e) => e.Id == nuevaEmpresa.Id);

    if (existe) {
      print("⚠️ Ya existe una empresa con el ID '${nuevaEmpresa.Id}'. Usa actualizarEmpresa().");
      return;
    }

    listaEmpresas.add(nuevaEmpresa);
    print("✅ Empresa guardada correctamente: ${nuevaEmpresa.Nombre}");
  }

  // 🔹 2. Eliminar empresa por ID
  void eliminarEmpresa(String id) {
    int index = listaEmpresas.indexWhere((e) => e.Id == id);

    if (index == -1) {
      print("⚠️ No se encontró la empresa con ID '$id'");
      return;
    }

    print("🗑️ Empresa eliminada: ${listaEmpresas[index].Nombre}");
    listaEmpresas.removeAt(index);
  }

  // 🔹 3. Obtener una empresa por ID
  Empresa? obtenerEmpresaPorId(String id) {
    try {
      return listaEmpresas.firstWhere((e) => e.Id == id);
    } catch (e) {
      print("⚠️ No se encontró la empresa con ID '$id'");
      return null;
    }
  }

  // 🔹 4. Obtener todas las empresas
  List<Empresa> obtenerEmpresas() {
    if (listaEmpresas.isEmpty) {
      print("⚠️ No hay empresas registradas.");
    }
    return listaEmpresas;
  }

  // 🔹 5. Actualizar una empresa existente
  void actualizarEmpresa(Empresa empresaActualizada) {
    int index = listaEmpresas.indexWhere((e) => e.Id == empresaActualizada.Id);

    if (index == -1) {
      print("⚠️ No se encontró empresa con ID '${empresaActualizada.Id}'");
      return;
    }

    listaEmpresas[index] = empresaActualizada;
    print("🔄 Empresa actualizada: ${empresaActualizada.Nombre}");
  }

  // 🔹 6. Agregar servicio a una empresa específica
  void agregarServicio(String idEmpresa, servicio) {
    Empresa? empresa = obtenerEmpresaPorId(idEmpresa);

    if (empresa == null) {
      print("⚠️ No se encontró la empresa con ID '$idEmpresa'");
      return;
    }

    empresa.ListaDeServicios ??= [];
    empresa.ListaDeServicios!.add(servicio);
    print("🧩 Servicio agregado a la empresa: ${empresa.Nombre}");
  }

  // 🔹 7. Agregar empleado a una empresa específica
  void agregarEmpleado(String idEmpresa, empleado) {
    Empresa? empresa = obtenerEmpresaPorId(idEmpresa);

    if (empresa == null) {
      print("⚠️ No se encontró la empresa con ID '$idEmpresa'");
      return;
    }

    empresa.ListaDeEmpleados ??= [];
    empresa.ListaDeEmpleados!.add(empleado);
    print("👨‍💼 Empleado agregado a la empresa: ${empresa.Nombre}");
  }

  // 🔹 8. Mostrar resumen de todas las empresas
  void mostrarResumenEmpresas() {
    if (listaEmpresas.isEmpty) {
      print("⚠️ No hay empresas registradas.");
      return;
    }

    for (var e in listaEmpresas) {
      print("""
🏢 Empresa: ${e.Nombre}
⭐ Estrellas: ${e.Estrellas}
📧 Correo: ${e.Correo}
📍 Ubicación: ${e.DescripcionUbicacion ?? 'No definida'}
👥 Empleados: ${e.ListaDeEmpleados?.length ?? 0}
🧩 Servicios: ${e.ListaDeServicios?.length ?? 0}
📅 Reservaciones: ${e.ListaDeReservaciones?.length ?? 0}
-----------------------------------------
""");
    }
  }
}
