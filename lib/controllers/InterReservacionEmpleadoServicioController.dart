import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/models/Reservacion.dart';

/// ✅ CONTROLADOR PARA TABLA DE INTERSECCIÓN TRIPLE
/// Tabla: Inter_Servicio_Reservacion
/// Relaciona: Reservacion ↔ Empleado ↔ Servicio
class InterReservacionEmpleadoServicioController {
  // Singleton
  static final InterReservacionEmpleadoServicioController _instance = 
      InterReservacionEmpleadoServicioController._internal();
  factory InterReservacionEmpleadoServicioController() => _instance;
  InterReservacionEmpleadoServicioController._internal();

  /// ✅ Guardar relaciones de una reservación completa
  /// Recibe el objeto Reservacion con su lista de empleados y servicios
  Future<bool> guardarRelacionesReservacion(Reservacion reservacion) async {
    try {
      // Validar que exista el ID de la reservación
      if (reservacion.Id == null || reservacion.Id!.isEmpty) {
        print('❌ Error: La reservación no tiene ID');
        return false;
      }

      // Validar que existan empleados asignados
      if (reservacion.empleadosAsignados.isEmpty) {
        print('⚠️ Advertencia: No hay empleados asignados en la reservación');
        return true; // No es un error, simplemente no hay nada que guardar
      }

      List<Map<String, dynamic>> registros = [];

      print('📝 Preparando registros para Inter_Servicio_Reservacion:');
      print('   Reservación ID: ${reservacion.Id}');

      // ✅ Recorrer cada empleado y sus servicios
      for (var empleado in reservacion.empleadosAsignados) {
        if (empleado.Id == null || empleado.Id!.isEmpty) {
          print('   ⚠️ Empleado sin ID detectado, saltando...');
          continue;
        }

        print('   👤 Empleado: ${empleado.Id} (${empleado.PrimerNombre})');

        // Validar que el empleado tenga servicios
        if (empleado.ListaDeServiciosDelEmpleado == null || 
            empleado.ListaDeServiciosDelEmpleado!.isEmpty) {
          print('   ⚠️ Empleado ${empleado.Id} no tiene servicios asignados');
          continue;
        }

        // Crear un registro por cada servicio del empleado
        for (var servicio in empleado.ListaDeServiciosDelEmpleado!) {
          if (servicio.Id.isEmpty) {
            print('   ⚠️ Servicio sin ID detectado, saltando...');
            continue;
          }

          print('      ✂️ Servicio: ${servicio.Id} (${servicio.Nombre})');

          registros.add({
            'Id_Reservaciones': reservacion.Id,  // ✅ Nota: es plural
            'Id_Empleado': empleado.Id,
            'Id_Servicio': servicio.Id,
          });
        }
      }

      // Validar que haya registros para insertar
      if (registros.isEmpty) {
        print('⚠️ No hay registros válidos para insertar en la intersección');
        return true;
      }

      print('📤 Insertando ${registros.length} relaciones en Inter_Servicio_Reservacion:');
      for (var registro in registros) {
        print('   - ${registro}');
      }

      // ✅ Insertar todos los registros en la tabla de intersección
      await SupabaseService.client
          .from('Inter_Servicio_Reservacion')
          .insert(registros);

      print('✅ ${registros.length} relaciones guardadas correctamente');
      return true;

    } catch (e) {
      print('❌ Error guardando relaciones de reservación: $e');
      print('   Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  /// ✅ Obtener empleados y servicios de una reservación
  /// Retorna un Map donde:
  /// - key: ID del empleado
  /// - value: Lista de IDs de servicios
  Future<Map<String, List<String>>> obtenerRelacionesPorReservacion(
    String reservacionId,
  ) async {
    try {
      print('🔍 Buscando relaciones para reservación: $reservacionId');
      
      final respuesta = await SupabaseService.client
          .from('Inter_Servicio_Reservacion')
          .select('Id_Empleado, Id_Servicio')
          .eq('Id_Reservaciones', reservacionId);  // ✅ Nota: es plural

      print('📥 Respuesta de Supabase: $respuesta');

      // Organizar datos por empleado
      Map<String, List<String>> empleadoServicios = {};

      for (var item in respuesta as List) {
        final empleadoId = item['Id_Empleado'] as String;
        final servicioId = item['Id_Servicio'] as String;

        if (!empleadoServicios.containsKey(empleadoId)) {
          empleadoServicios[empleadoId] = [];
        }
        empleadoServicios[empleadoId]!.add(servicioId);
      }

      print('📋 Relaciones organizadas: $empleadoServicios');
      print('   Total empleados: ${empleadoServicios.length}');
      
      return empleadoServicios;

    } catch (e) {
      print('❌ Error obteniendo relaciones de reservación: $e');
      print('   Stack trace: ${StackTrace.current}');
      return {};
    }
  }

  /// ✅ Eliminar todas las relaciones de una reservación
  Future<bool> eliminarRelacionesReservacion(String reservacionId) async {
    try {
      print('🗑️ Eliminando relaciones de reservación: $reservacionId');
      
      await SupabaseService.client
          .from('Inter_Servicio_Reservacion')
          .delete()
          .eq('Id_Reservaciones', reservacionId);  // ✅ Nota: es plural

      print('✅ Relaciones de la reservación $reservacionId eliminadas');
      return true;

    } catch (e) {
      print('❌ Error eliminando relaciones de reservación: $e');
      return false;
    }
  }

  /// ✅ Verificar si una combinación específica existe
  Future<bool> existeRelacion({
    required String reservacionId,
    required String empleadoId,
    required String servicioId,
  }) async {
    try {
      final respuesta = await SupabaseService.client
          .from('Inter_Servicio_Reservacion')
          .select('Id')
          .eq('Id_Reservaciones', reservacionId)  // ✅ Nota: es plural
          .eq('Id_Empleado', empleadoId)
          .eq('Id_Servicio', servicioId)
          .maybeSingle();

      final existe = respuesta != null;
      print(existe 
          ? '✅ Relación encontrada: R:$reservacionId - E:$empleadoId - S:$servicioId'
          : '❌ Relación NO existe: R:$reservacionId - E:$empleadoId - S:$servicioId');
      
      return existe;

    } catch (e) {
      print('❌ Error verificando relación: $e');
      return false;
    }
  }

  /// ✅ Obtener todas las reservaciones de un empleado específico
  Future<List<String>> obtenerReservacionesPorEmpleado(String empleadoId) async {
    try {
      print('🔍 Buscando reservaciones del empleado: $empleadoId');
      
      final respuesta = await SupabaseService.client
          .from('Inter_Servicio_Reservacion')
          .select('Id_Reservaciones')  // ✅ Nota: es plural
          .eq('Id_Empleado', empleadoId);

      final reservacionesIds = (respuesta as List)
          .map((item) => item['Id_Reservaciones'] as String)
          .toSet()
          .toList();

      print('📅 Empleado $empleadoId tiene ${reservacionesIds.length} reservaciones');
      return reservacionesIds;

    } catch (e) {
      print('❌ Error obteniendo reservaciones del empleado: $e');
      return [];
    }
  }

  /// ✅ Obtener empleados que realizaron un servicio específico
  Future<List<String>> obtenerEmpleadosPorServicio(String servicioId) async {
    try {
      print('🔍 Buscando empleados que realizaron el servicio: $servicioId');
      
      final respuesta = await SupabaseService.client
          .from('Inter_Servicio_Reservacion')
          .select('Id_Empleado')
          .eq('Id_Servicio', servicioId);

      final empleadosIds = (respuesta as List)
          .map((item) => item['Id_Empleado'] as String)
          .toSet()
          .toList();

      print('👥 Servicio $servicioId fue realizado por ${empleadosIds.length} empleados diferentes');
      return empleadosIds;

    } catch (e) {
      print('❌ Error obteniendo empleados por servicio: $e');
      return [];
    }
  }

  /// ✅ NUEVO: Obtener todas las relaciones de una reservación (con nombres)
  /// Útil para debugging o reportes detallados
  Future<List<Map<String, dynamic>>> obtenerRelacionesDetalladas(
    String reservacionId,
  ) async {
    try {
      print('🔍 Obteniendo relaciones detalladas para: $reservacionId');
      
      final respuesta = await SupabaseService.client
          .from('Inter_Servicio_Reservacion')
          .select('''
            Id,
            created_at,
            Id_Reservaciones,
            Id_Empleado,
            Id_Servicio,
            Empleados (
              PrimerNombre,
              PrimerApellido,
              Cargo
            ),
            Servicios (
              Nombre,
              Precio,
              Descripcion
            )
          ''')
          .eq('Id_Reservaciones', reservacionId);

      print('📥 ${(respuesta as List).length} relaciones detalladas encontradas');
      
      return respuesta as List<Map<String, dynamic>>;

    } catch (e) {
      print('❌ Error obteniendo relaciones detalladas: $e');
      print('   Nota: Asegúrate que las FKs en Supabase permitan el JOIN');
      return [];
    }
  }

  /// ✅ NUEVO: Obtener estadísticas de un servicio
  /// Cuántas veces se ha reservado, por cuántos empleados diferentes
  Future<Map<String, int>> obtenerEstadisticasServicio(String servicioId) async {
    try {
      final respuesta = await SupabaseService.client
          .from('Inter_Servicio_Reservacion')
          .select('Id_Reservaciones, Id_Empleado')
          .eq('Id_Servicio', servicioId);

      final reservacionesUnicas = (respuesta as List)
          .map((item) => item['Id_Reservaciones'])
          .toSet()
          .length;

      final empleadosUnicos = (respuesta as List)
          .map((item) => item['Id_Empleado'])
          .toSet()
          .length;

      print('📊 Estadísticas del servicio $servicioId:');
      print('   - Total reservaciones: $reservacionesUnicas');
      print('   - Empleados diferentes: $empleadosUnicos');

      return {
        'total_reservaciones': reservacionesUnicas,
        'total_empleados': empleadosUnicos,
      };

    } catch (e) {
      print('❌ Error obteniendo estadísticas: $e');
      return {'total_reservaciones': 0, 'total_empleados': 0};
    }
  }

  /// ✅ NUEVO: Obtener carga de trabajo de un empleado
  /// Cuántas reservaciones tiene pendientes
  Future<int> obtenerCargaTrabajoEmpleado(String empleadoId) async {
    try {
      final respuesta = await SupabaseService.client
          .from('Inter_Servicio_Reservacion')
          .select('Id_Reservaciones')
          .eq('Id_Empleado', empleadoId);

      final totalReservaciones = (respuesta as List)
          .map((item) => item['Id_Reservaciones'])
          .toSet()
          .length;

      print('💼 Empleado $empleadoId tiene $totalReservaciones reservaciones');
      return totalReservaciones;

    } catch (e) {
      print('❌ Error obteniendo carga de trabajo: $e');
      return 0;
    }
  }
}