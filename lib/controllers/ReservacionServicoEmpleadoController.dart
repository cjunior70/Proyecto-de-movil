import 'package:proyecto/models/Servicio.dart';
import 'package:proyecto/models/Reservacion.dart';
import 'package:proyecto/models/Empleado.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InterServicioReservacionController {
  final supabase = Supabase.instance.client;

  final String tabla = "Inter_Servicio_Reservacion";

  Future<bool> registrarDesdeReservacion(Reservacion reservacion) async {
    try {
      if (reservacion.Id == null) {
        //print("❌ La reservación NO tiene Id aún.");
        return false;
      }

      if (reservacion.empleadosAsignados == null || reservacion.empleadosAsignados!.isEmpty) {
        //print("⚠ La reservación no tiene empleados.");
        return false;
      }

      for (Empleado emp in reservacion.empleadosAsignados!) {
        if (emp.ListaDeServiciosDelEmpleado == null || emp.ListaDeServiciosDelEmpleado!.isEmpty) continue;

        for (Servicio serv in emp.ListaDeServiciosDelEmpleado!) {
          final data = {
            "Id_Reservacion": reservacion.Id,
            "Id_Empleado": emp.Id,
            "Id_Servicio": serv.Id,
          };

          final response = await supabase.from(tabla).insert(data);

          if (response.isEmpty) {
            //print("❌ Error insertando servicio-intermedio");
            return false;
          }
        }
      }

      //print("✅ Servicios y empleados registrados correctamente.");
      return true;
    } catch (e) {
      //print("❌ Error registrarDesdeReservacion: $e");
      return false;
    }
  }


  Future<List<Map<String, dynamic>>> obtenerPorReservacion(int idReservacion) async {
    try {
      final response = await supabase
          .from(tabla)
          .select("*")
          .eq("Id_Reservacion", idReservacion);

      return response;
    } catch (e) {
      //print("❌ Error obtenerPorReservacion: $e");
      return [];
    }
  }


  Future<bool> actualizar({
    required int id,
    int? idEmpleado,
    int? idServicio,
  }) async {
    try {
      final updateData = {
        if (idEmpleado != null) "Id_Empleado": idEmpleado,
        if (idServicio != null) "Id_Servicio": idServicio,
      };

      final response = await supabase.from(tabla).update(updateData).eq("Id", id);

      if (response.isEmpty) return false;

      //print("✅ Registro intermedio actualizado.");
      return true;
    } catch (e) {
      //print("❌ Error actualizar: $e");
      return false;
    }
  }

  Future<bool> eliminar(int id) async {
    try {
      final response = await supabase.from(tabla).delete().eq("Id", id);

      if (response.isEmpty) return false;

      //print("🗑 Registro eliminado correctamente.");
      return true;
    } catch (e) {
      //print("❌ Error eliminar: $e");
      return false;
    }
  }


  Future<bool> eliminarPorReservacion(int idReservacion) async {
    try {
      await supabase.from(tabla).delete().eq("Id_Reservacion", idReservacion);

      //print("🗑 Todos los servicios de la reservación fueron eliminados.");
      return true;
    } catch (e) {
      //print("❌ Error eliminarPorReservacion: $e");
      return false;
    }
  }
}
