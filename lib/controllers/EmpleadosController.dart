import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/models/Empleado.dart';

class EmpleadoController {
  Empleado? empleado; // único empleado en memoria
  List<Empleado> lista_de_Empleados = [];

  // 🔹 1. Guardar empleado
  Future<bool> guardarEmpleado(Empleado nuevoEmpleado) async {
    try {
      empleado = nuevoEmpleado;

      await SupabaseService.client
          .from('Empleados')
          .insert(nuevoEmpleado.toJson());

      print("Empleado insertado correctamente en Supabase");
      return true;
    } catch (e) {
      print("Hay un problema en el guardado del Empleado + $e");
      return false;
    }
  }

  // 🔹 2. Obtener empleados por empresa
  Future<List<Empleado>> obtenerEmpleadosPorEmpresa(String empresaId) async {
    try {
      final respuesta = await SupabaseService.client
          .from('Empleados')
          .select()
          .eq("Id_Empresa", empresaId);

      print("Empleados encontrados correctamente en Supabase: $respuesta");

      final List<Empleado> listaEmpleados = (respuesta as List)
          .map((e) => Empleado.fromJson(e as Map<String, dynamic>))
          .toList();

      lista_de_Empleados = listaEmpleados;
      print(listaEmpleados);
      return listaEmpleados;
    } catch (e) {
      print("Hay un problema al obtener los Empleados: $e");
      return [];
    }
  }

  // ✅ NUEVO: Obtener UN empleado por ID
  Future<Empleado?> obtenerEmpleado(String empleadoId) async {
    try {
      final respuesta = await SupabaseService.client
          .from('Empleados')
          .select()
          .eq("Id", empleadoId)
          .maybeSingle(); // Obtiene un solo registro o null

      if (respuesta == null) {
        print("⚠️ No se encontró empleado con ID: $empleadoId");
        return null;
      }

      print("✅ Empleado encontrado: $respuesta");

      final empleado = Empleado.fromJson(respuesta as Map<String, dynamic>);
      return empleado;
    } catch (e) {
      print("❌ Error al obtener empleado $empleadoId: $e");
      return null;
    }
  }

  // 🔹 3. Actualizar empleado existente
  Future<bool> actualizarEmpleado(Empleado empleadoActualizado) async {
    try {
      await SupabaseService.client
          .from('Empleados')
          .update(empleadoActualizado.toJson())
          .eq("Id", empleadoActualizado.Id!);

      print("Empleado actualizado correctamente en Supabase");
      return true;
    } catch (e) {
      print("Hay un problema al actualizar el Empleado + $e");
      return false;
    }
  }

  // 🔹 4. Eliminar empleado por ID
  Future<bool> eliminarEmpleado(String id) async {
    try {
      await SupabaseService.client
          .from('Empleados')
          .delete()
          .eq("Id", id);

      print("Empleado borrado correctamente en Supabase");
      return true;
    } catch (e) {
      print("Hay un problema al eliminar el Empleado + $e");
      return false;
    }
  }
}