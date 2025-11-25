import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/Models/Contabilidad.dart';

class ContabilidadController {
  Contabilidad? contabilidad;
  List<Contabilidad> ListadeContabilidadesdeempresas = [];

  /// ✅ Obtener contabilidad de la empresa
  Future<List<Contabilidad>> obtenerContabilidadesPorEmpresa(String Empresa_id) async {
    try {
      final respuesta = await SupabaseService.client
          .from('Contabilidad')
          .select()
          .eq("Id_Empresa", Empresa_id);

      print("Contabilidads encontradas correctamente en Supabase: $respuesta");

      final List<Contabilidad> listaContabilidads = (respuesta as List)
          .map((e) => Contabilidad.fromJson(e as Map<String, dynamic>))
          .toList();

      ListadeContabilidadesdeempresas = listaContabilidads;
      print(listaContabilidads);
      return listaContabilidads;
    } catch (e) {
      print("Hay un problema al obtener las Contabilidads: $e");
      return [];
    }
  }

  /// ✅ NUEVO: Obtener ganancias REALES basadas en servicios reservados
  /// Calcula el total sumando los precios de los servicios de cada reservación
  Future<Map<String, dynamic>> obtenerGananciasRealesPorEmpresa({
    required String empresaId,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      print('💰 Calculando ganancias reales para empresa: $empresaId');

      // 🔍 PASO 1: Obtener todas las reservaciones de la empresa
      var queryReservaciones = SupabaseService.client
          .from('Reservaciones')
          .select('Id, Fecha, Estado, Valor')
          .eq('Id_Empresa', empresaId);

      // Filtrar por fechas si se proporcionan
      if (fechaInicio != null) {
        queryReservaciones = queryReservaciones.gte('Fecha', fechaInicio.toIso8601String());
      }
      if (fechaFin != null) {
        queryReservaciones = queryReservaciones.lte('Fecha', fechaFin.toIso8601String());
      }

      final reservaciones = await queryReservaciones;
      print('📅 Reservaciones encontradas: ${(reservaciones as List).length}');

      if (reservaciones.isEmpty) {
        return {
          'total': 0.0,
          'cantidadReservaciones': 0,
          'serviciosMasVendidos': <Map<String, dynamic>>[],
        };
      }

      double totalGanancias = 0.0;
      Map<String, Map<String, dynamic>> serviciosContador = {};

      // 🔍 PASO 2: Para cada reservación, obtener sus servicios
      for (var reservacion in reservaciones) {
        final reservacionId = reservacion['Id'] as String;

        // Obtener servicios de la reservación desde la tabla de intersección
        final serviciosReservacion = await SupabaseService.client
            .from('Inter_Servicio_Reservacion')
            .select('''
              Id_Servicio,
              Servicios (
                Nombre,
                Precio
              )
            ''')
            .eq('Id_Reservaciones', reservacionId);

        // Sumar precios de los servicios
        for (var item in serviciosReservacion as List) {
          final servicio = item['Servicios'];
          if (servicio != null) {
            final servicioId = item['Id_Servicio'] as String;
            final nombre = servicio['Nombre'] as String? ?? 'Sin nombre';
            final precio = servicio['Precio'] != null 
                ? (servicio['Precio'] as num).toDouble() 
                : 0.0;

            totalGanancias += precio;

            // Contar servicios para estadísticas
            if (!serviciosContador.containsKey(servicioId)) {
              serviciosContador[servicioId] = {
                'nombre': nombre,
                'precio': precio,
                'cantidad': 0,
                'total': 0.0,
              };
            }

            serviciosContador[servicioId]!['cantidad'] = 
                (serviciosContador[servicioId]!['cantidad'] as int) + 1;
            serviciosContador[servicioId]!['total'] = 
                (serviciosContador[servicioId]!['total'] as double) + precio;
          }
        }
      }

      // Ordenar servicios por cantidad vendida (mayor a menor)
      final serviciosMasVendidos = serviciosContador.entries
          .map((e) => {
                'id': e.key,
                'nombre': e.value['nombre'],
                'precio': e.value['precio'],
                'cantidad': e.value['cantidad'],
                'total': e.value['total'],
              })
          .toList()
        ..sort((a, b) => (b['cantidad'] as int).compareTo(a['cantidad'] as int));

      print('✅ Ganancias calculadas:');
      print('   Total: \$${totalGanancias.toStringAsFixed(2)}');
      print('   Reservaciones: ${reservaciones.length}');
      print('   Servicios diferentes: ${serviciosContador.length}');

      return {
        'total': totalGanancias,
        'cantidadReservaciones': reservaciones.length,
        'serviciosMasVendidos': serviciosMasVendidos,
      };
    } catch (e) {
      print('❌ Error calculando ganancias reales: $e');
      return {
        'total': 0.0,
        'cantidadReservaciones': 0,
        'serviciosMasVendidos': <Map<String, dynamic>>[],
      };
    }
  }

  /// ✅ NUEVO: Obtener ganancias de todas las empresas de un usuario
  Future<Map<String, dynamic>> obtenerGananciasTotalesUsuario({
    required List<String> empresasIds,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      print('💰 Calculando ganancias totales para ${empresasIds.length} empresas');

      double totalGeneral = 0.0;
      int totalReservaciones = 0;
      Map<String, double> gananciasPorEmpresa = {};

      for (var empresaId in empresasIds) {
        final resultado = await obtenerGananciasRealesPorEmpresa(
          empresaId: empresaId,
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        );

        final ganancia = resultado['total'] as double;
        gananciasPorEmpresa[empresaId] = ganancia;
        totalGeneral += ganancia;
        totalReservaciones += resultado['cantidadReservaciones'] as int;
      }

      print('✅ Ganancias totales: \$${totalGeneral.toStringAsFixed(2)}');

      return {
        'totalGeneral': totalGeneral,
        'totalReservaciones': totalReservaciones,
        'gananciasPorEmpresa': gananciasPorEmpresa,
      };
    } catch (e) {
      print('❌ Error calculando ganancias totales: $e');
      return {
        'totalGeneral': 0.0,
        'totalReservaciones': 0,
        'gananciasPorEmpresa': <String, double>{},
      };
    }
  }
}