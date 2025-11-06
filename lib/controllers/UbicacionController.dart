import 'package:proyecto/Conexion/supabase_service.dart';
import 'package:proyecto/models/Ubicacion.dart';

class UbicacionController {
  
  Ubicacion? datosdeUbicacion; // Solo una ubicación cargada en memoria

   List<Ubicacion> lista_de_Ubicaciones = [];

  //  Guardar ubicación (recibe el objeto completo)
  Future<bool> guardarUbicacion(Ubicacion nuevoUbicacion) async {
    try{

      //Guardar los daots del Ubicacion temporalmente
      datosdeUbicacion = nuevoUbicacion;

      await SupabaseService.client
          .from('Ubicacion')
          .insert(nuevoUbicacion.toJson());

      print("Ubicacion insertado correctamente en Supabase");

      return true;

    }
    catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el guardado del Ubicacion + $e" );

      return false;
    }
  }

  //  Obtener ubicación actual
  Future<List<Ubicacion>> obtenerTodasUbicacions() async {
  try {
    final respuesta = await SupabaseService.client
        .from('Ubicacion')
        .select();

    print("Ubicacions encontradas correctamente en Supabase: $respuesta");

    // Convertir la lista de mapas a lista de objetos Ubicacion
    final List<Ubicacion> listaUbicacions = (respuesta as List)
        .map((e) => Ubicacion.fromJson(e as Map<String, dynamic>))
        .toList();

    lista_de_Ubicaciones = listaUbicacions;
    return listaUbicacions;
  } catch (e) {
    print("Hay un problema al obtener las Ubicacions: $e");
    return [];
  }
}

  Future<List<Ubicacion>> obtenerUbicacionsPorId(String usuarioId) async {
  try {
    final respuesta = await SupabaseService.client
        .from('Ubicacion')
        .select()
        .eq("Id", usuarioId);

    print("Ubicacions encontradas correctamente en Supabase: $respuesta");

    // Convertir la lista de mapas a lista de objetos Ubicacion
    final List<Ubicacion> listaUbicacions = (respuesta as List)
        .map((e) => Ubicacion.fromJson(e as Map<String, dynamic>))
        .toList();

    lista_de_Ubicaciones = listaUbicacions;
    print(listaUbicacions);
    return listaUbicacions;
  } catch (e) {
    print("Hay un problema al obtener las Ubicacions: $e");
    return [];
  }
}

  // Actualizar ubicación existente
 Future<bool> actualizarUbicacion(Ubicacion UbicacionActualizado) async {
    try{

      await SupabaseService.client
          .from('Ubicacion')
          .update(UbicacionActualizado.toJson()) //Los datoa actualizados convertidos a json
          .eq("Id", UbicacionActualizado.Id!);

      print("Ubicacion actualizados correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el Ubicacion + $e" );

      return false;
    }
  }

  // ✅ Eliminar ubicación
  Future<bool> eliminarUbicacion(String Id)  async{
    try{

      await SupabaseService.client
          .from('Ubicacion')
          .delete()
          .eq("Id",Id);

      print("Ubicacion borrado correctamente en Supabase");

      return true;

    }catch(e)
    {
      //Es necesario concatenar
      print("Hay un problema en el eliminar el Ubicacion + $e" );

      return false;
    }
  }

}
