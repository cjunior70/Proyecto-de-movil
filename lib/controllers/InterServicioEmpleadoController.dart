import 'package:proyecto/Conexion/supabase_service.dart';

/// ✅ CONTROLADOR PARA LA TABLA DE INTERSECCIÓN Servicio-Empleado
class InterServicioEmpleadoController {
  // Singleton
  static final InterServicioEmpleadoController _instance = 
      InterServicioEmpleadoController._internal();
  factory InterServicioEmpleadoController() => _instance;
  InterServicioEmpleadoController._internal();

  /// 1. Asignar servicios a un empleado
  /// Elimina asignaciones previas y crea las nuevas
  Future<bool> asignarServiciosAEmpleado({
    required String empleadoId,
    required Set<String> serviciosIds,
  }) async {
    try {
      // ✅ 1. Eliminar todas las asignaciones previas del empleado
      await SupabaseService.client
          .from('Inter_Servicio_Empleado')
          .delete()
          .eq('Id_Empleado', empleadoId);

      //print('🗑️ Asignaciones previas eliminadas para empleado: $empleadoId');

      // ✅ 2. Si no hay servicios seleccionados, terminar aquí
      if (serviciosIds.isEmpty) {
        //print('✅ No hay servicios para asignar');
        return true;
      }

      // ✅ 3. Crear las nuevas asignaciones
      final asignaciones = serviciosIds.map((servicioId) {
        return {
          'Id_Empleado': empleadoId,
          'Id_Servicio': servicioId,
        };
      }).toList();

      await SupabaseService.client
          .from('Inter_Servicio_Empleado')
          .insert(asignaciones);

      //print('✅ ${asignaciones.length} servicios asignados correctamente');
      return true;

    } catch (e) {
      //print('❌ Error asignando servicios al empleado: $e');
      return false;
    }
  }

  /// 2. Obtener IDs de servicios asignados a un empleado
  Future<Set<String>> obtenerServiciosDeEmpleado(String empleadoId) async {
    try {
      final respuesta = await SupabaseService.client
          .from('Inter_Servicio_Empleado')
          .select('Id_Servicio')
          .eq('Id_Empleado', empleadoId);

      //print('📋 Servicios del empleado obtenidos: $respuesta');

      // Convertir a Set<String>
      final serviciosIds = (respuesta as List)
          .map((item) => item['Id_Servicio'] as String)
          .toSet();

      return serviciosIds;

    } catch (e) {
      //print('❌ Error obteniendo servicios del empleado: $e');
      return {};
    }
  }

  /// 3. Obtener IDs de empleados que tienen un servicio específico
  Future<Set<String>> obtenerEmpleadosDeServicio(String servicioId) async {
    try {
      final respuesta = await SupabaseService.client
          .from('Inter_Servicio_Empleado')
          .select('Id_Empleado')
          .eq('Id_Servicio', servicioId);

      //print('👥 Empleados con el servicio obtenidos: $respuesta');

      // Convertir a Set<String>
      final empleadosIds = (respuesta as List)
          .map((item) => item['Id_Empleado'] as String)
          .toSet();

      return empleadosIds;

    } catch (e) {
      //print('❌ Error obteniendo empleados del servicio: $e');
      return {};
    }
  }

  /// 4. Verificar si un empleado tiene un servicio asignado
  Future<bool> empleadoTieneServicio({
    required String empleadoId,
    required String servicioId,
  }) async {
    try {
      final respuesta = await SupabaseService.client
          .from('Inter_Servicio_Empleado')
          .select('Id')
          .eq('Id_Empleado', empleadoId)
          .eq('Id_Servicio', servicioId)
          .maybeSingle();

      return respuesta != null;

    } catch (e) {
      //print('❌ Error verificando asignación: $e');
      return false;
    }
  }

  /// 5. Eliminar asignación específica
  Future<bool> eliminarAsignacion({
    required String empleadoId,
    required String servicioId,
  }) async {
    try {
      await SupabaseService.client
          .from('Inter_Servicio_Empleado')
          .delete()
          .eq('Id_Empleado', empleadoId)
          .eq('Id_Servicio', servicioId);

      //print('✅ Asignación eliminada correctamente');
      return true;

    } catch (e) {
      //print('❌ Error eliminando asignación: $e');
      return false;
    }
  }

  /// 6. Obtener todos los servicios con sus empleados asignados
  Future<Map<String, List<String>>> obtenerServiciosConEmpleados(
    String empresaId,
  ) async {
    try {
      // Esto requeriría un join complejo, por ahora devolvemos un mapa vacío
      // Puedes implementarlo según tus necesidades
      return {};
    } catch (e) {
      //print('❌ Error obteniendo servicios con empleados: $e');
      return {};
    }
  }
}