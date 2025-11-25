import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/models/Servicio.dart';

class ServicioController {
  Servicio? servicio; // Solo un servicio cargado en memoria
  List<Servicio> listadeServicios = [];

  // ✅ 1. Guardar servicio
  Future<bool> guardarServicio(Servicio nuevoServicio) async {
    try {
      servicio = nuevoServicio;

      await SupabaseService.client
          .from('Servicios')
          .insert(nuevoServicio.toJson());

      print("Servicio insertado correctamente en Supabase");
      return true;
    } catch (e) {
      print("Hay un problema en el guardado del Servicio + $e");
      return false;
    }
  }

  // ✅ 2. Obtener servicios por empresa
  Future<List<Servicio>> obtenerTodasServiciosPorEmpresa(String idEmpresa) async {
    try {
      final respuesta = await SupabaseService.client
          .from('Servicios')
          .select()
          .eq("Id_Empresa", idEmpresa);

      print("Servicios encontrados correctamente en Supabase: $respuesta");

      final List<Servicio> listaServicios = (respuesta as List)
          .map((e) => Servicio.fromJson(e as Map<String, dynamic>))
          .toList();

      listadeServicios = listaServicios;
      return listaServicios;
    } catch (e) {
      print("Hay un problema al obtener los Servicios: $e");
      return [];
    }
  }

  // ✅ NUEVO: Obtener UN servicio por ID
  Future<Servicio?> obtenerServicio(String servicioId) async {
    try {
      final respuesta = await SupabaseService.client
          .from('Servicios')
          .select()
          .eq("Id", servicioId)
          .maybeSingle(); // Obtiene un solo registro o null

      if (respuesta == null) {
        print("⚠️ No se encontró servicio con ID: $servicioId");
        return null;
      }

      print("✅ Servicio encontrado: $respuesta");

      final servicio = Servicio.fromJson(respuesta as Map<String, dynamic>);
      return servicio;
    } catch (e) {
      print("❌ Error al obtener servicio $servicioId: $e");
      return null;
    }
  }

  // ✅ 3. Obtener servicios por ID (lista)
  Future<List<Servicio>> obtenerServiciosPorId(String usuarioId) async {
    try {
      final respuesta = await SupabaseService.client
          .from('Servicios')
          .select()
          .eq("Id", usuarioId);

      print("Servicios encontrados correctamente en Supabase: $respuesta");

      final List<Servicio> listaServicios = (respuesta as List)
          .map((e) => Servicio.fromJson(e as Map<String, dynamic>))
          .toList();

      listadeServicios = listaServicios;
      print(listaServicios);
      return listaServicios;
    } catch (e) {
      print("Hay un problema al obtener los Servicios: $e");
      return [];
    }
  }

  // ✅ 4. Actualizar servicio
  Future<bool> actualizarServicio(Servicio servicioActualizado) async {
    try {
      await SupabaseService.client
          .from('Servicios')
          .update(servicioActualizado.toJson())
          .eq("Id", servicioActualizado.Id);

      print("Servicio actualizado correctamente en Supabase");
      return true;
    } catch (e) {
      print("Hay un problema al actualizar el Servicio + $e");
      return false;
    }
  }

  // ✅ 5. Eliminar servicio
  Future<bool> eliminarServicio(String id) async {
    try {
      await SupabaseService.client
          .from('Servicios')
          .delete()
          .eq("Id", id);

      print("Servicio borrado correctamente en Supabase");
      return true;
    } catch (e) {
      print("Hay un problema al eliminar el Servicio + $e");
      return false;
    }
  }
}