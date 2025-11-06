import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/models/Servicio.dart';

class ServicioController {

  Servicio? servicio; // Solo un servicio cargado en memoria

  List<Servicio> listadeServicios = [];

  // ✅ Guardar servicio (recibe el objeto completo)
  Future<bool> guardarServicio(Servicio nuevoServicio) async {
    try{

      //Guardar los daots del Servicio temporalmente
      servicio = nuevoServicio;

      await SupabaseService.client
          .from('Servicios')
          .insert(nuevoServicio.toJson());

      print("Servicio insertado correctamente en Supabase");

      return true;

    }
    catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el guardado del Servicio + $e" );

      return false;
    }
  }

  Future<List<Servicio>> obtenerTodasServicios() async {
  try {
    final respuesta = await SupabaseService.client
        .from('Servicios')
        .select();

    print("Servicios encontradas correctamente en Supabase: $respuesta");

    // Convertir la lista de mapas a lista de objetos Servicio
    final List<Servicio> listaServicios = (respuesta as List)
        .map((e) => Servicio.fromJson(e as Map<String, dynamic>))
        .toList();

    listadeServicios = listaServicios;
    return listaServicios;
  } catch (e) {
    print("Hay un problema al obtener las Servicios: $e");
    return [];
  }
}

  // ✅ Obtener servicio actual
  Future<List<Servicio>> obtenerServiciosPorId(String usuarioId) async {
    try {
      final respuesta = await SupabaseService.client
          .from('Servicios')
          .select()
          .eq("Id", usuarioId);

      print("Servicios encontradas correctamente en Supabase: $respuesta");

      // Convertir la lista de mapas a lista de objetos Servicio
      final List<Servicio> listaServicios = (respuesta as List)
          .map((e) => Servicio.fromJson(e as Map<String, dynamic>))
          .toList();

      listadeServicios = listaServicios;
      print(listaServicios);
      return listaServicios;
    } catch (e) {
      print("Hay un problema al obtener las Servicios: $e");
      return [];
    }
  }

  // ✅ Actualizar servicio
  // 5. Actualizar una Servicio existente
  Future<bool> actualizarServicio(Servicio ServicioActualizado) async {
    try{

      await SupabaseService.client
          .from('Servicios')
          .update(ServicioActualizado.toJson()) //Los datoa actualizados convertidos a json
          .eq("Id", ServicioActualizado.Id!);

      print("Servicio actualizados correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el Servicio + $e" );

      return false;
    }
  }

  // ✅ Eliminar servicio
 Future<bool> eliminarServicio(String Id)  async{
    try{

      await SupabaseService.client
          .from('Servicios')
          .delete()
          .eq("Id",Id);

      print("Servicio borrado correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el Servicio + $e" );

      return false;
    }
  }
}
